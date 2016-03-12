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

@interface ChufangViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ChufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self showBackButtonWithImage:@"back"];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ChuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    if ([self.modelNum intValue] == 0) {
        [self getDateload];
    }
    if ([self.modelNum intValue] == 1) {
        [self getLoveData];
    }
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
        
        for (NSDictionary *listDic in list) {
            
            ChuModer *model = [[ChuModer alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:model];
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"出错"];
        NSLog(@"%@",error);
    }];
}

- (void)getLoveData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"为你加载数据"];
    /*
     http://api.haodou.com/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1457588594904&vc=82&vn=6.0.3&loguid=0&deviceid=haodou864301020205370&uuid=fb27cc857abaff75ff3eb8a7d0f8fa20&channel=oppo_v603&method=Search.getList&virtual=&signmethod=md5&v=2&timestamp=1457593172&nonce=0.5861222196259378&appsign=ab22969c636227ea83d24fd3e83db586
     
     */
    [manager GET:[NSString stringWithFormat:@"%@%@",kTodayAction,self.modelId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"成功加载"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *list = result[@"list"];
        
        for (NSDictionary *listDic in list) {
            LoveModel *mModel = [[LoveModel alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:mModel];
        }
        [self.tableView reloadData];
        
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
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MianVC" bundle:nil];
            StoryViewController *storyVC = [storyBoard instantiateViewControllerWithIdentifier:@"story"];
            storyVC.title = model.title;
            storyVC.videoId = model.loveID;
            [self.navigationController pushViewController:storyVC animated:YES];
        }
    }
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
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
