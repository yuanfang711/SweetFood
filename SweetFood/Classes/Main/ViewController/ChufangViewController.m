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
    
    [self getDateload];
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

    HotThemeController *hotVC = [[HotThemeController alloc] init];
    ChuModer *model = self.listArray[indexPath.row];
    hotVC.title = model.title;
    hotVC.htmlUrl = model.cellUrl;
    hotVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotVC animated:YES];
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
