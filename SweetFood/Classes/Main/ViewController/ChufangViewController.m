//
//  ChufangViewController.m
//  厨房宝典
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ChufangViewController.h"
#import "ChuTableViewCell.h"
#import "ChuModer.h"
#import "HotThemeController.h"
#import "UIViewController+Common.h"
#import "LoveModel.h"
#import "StoryViewController.h"
#import "ActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "ProgressHUD.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ChufangViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    BOOL _ieRefreching;
    NSInteger _pageNum;
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ChufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self showBackButtonWithImage:@"back"];
    _ieRefreching = NO;
    _pageNum = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ChuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    if ([self.modelNum intValue] == 0) {
        [self getDateload];
    }
    if ([self.modelNum intValue] == 1) {
        [self getLoveData];
    }
    self.tableView.tableFooterView = [UIView new];
    [self.tableView launchRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark -------- 请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"为你加载数据"];
    [manager GET:self.getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"成功加载"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *list = result[@"list"];
        if (_ieRefreching) {
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }
        }
        for (NSDictionary *listDic in list) {
            
            ChuModer *model = [[ChuModer alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:model];
            
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"出错"];
        NSLog(@"%@",error);
    }];
}

- (void)getLoveData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"为你加载数据"];
    [manager GET:[NSString stringWithFormat:@"%@%@&offset=%ld",kTodayAction,self.modelId,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"成功加载"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *list = result[@"list"];
        if (_ieRefreching) {
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }
        }
        for (NSDictionary *listDic in list) {
            LoveModel *mModel = [[LoveModel alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:mModel];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"出错"];
        NSLog(@"%@",error);
    }];
}

#pragma mark -------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.modelNum intValue] == 0) {
        HotThemeController *hotVC = [[HotThemeController alloc] init];
        ChuModer *model = self.listArray[indexPath.row];
        hotVC.title = model.title;
        hotVC.htmlUrl = model.cellUrl;
        hotVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotVC animated:YES];
    }
    if ([self.modelNum intValue] == 1) {
        
       LoveModel *model = self.listArray[indexPath.row];
        if ([model.type intValue] == 0) {
            ActivityViewController *actiVC = [[ActivityViewController alloc ]init];
            actiVC.fooDid = model.loveID;
            actiVC.title = model.title;
            [self.navigationController pushViewController:actiVC animated:YES];
            
        }
        if ([model.type intValue] == 1) {
            StoryViewController *storyVC = [[StoryViewController alloc] init];
            storyVC.title = model.title;
            storyVC.videoId = model.loveID;
            [self.navigationController pushViewController:storyVC animated:YES];
        }
    }
}
#pragma mark  ------------ 刷新代理

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _ieRefreching = YES;
    _pageNum = 0;
    [self performSelector:@selector(getLoveData) withObject:nil afterDelay:1.0 ];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _ieRefreching = NO;
    _pageNum += 20;
      [self performSelector:@selector(getLoveData) withObject:nil afterDelay:1.0 ];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark  ------------ 懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight-64) style:UITableViewStylePlain];
        self.tableView.pullingDelegate = self;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 110;
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
