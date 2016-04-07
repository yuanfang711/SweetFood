//
//  TodayViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//
#import "TodayViewController.h"
#import "TodayTableViewCell.h"
#import "TodayModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProgressHUD.h"
#import "UIViewController+Common.h"

@interface TodayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ListArray;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"今日特价";
        [self showBackButtonWithImage:@"back"];
    
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TodayTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getDateload];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark -------- 请求数据
- (void)getDateload{
     [ProgressHUD show:@"正在请求"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  
    [manager GET:@"http://api.haodou.com/mall/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=194835c2ec88e7c4b3b7b8041e98d0e1&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C2F8CCE8D-7B19-4DFD-BA50-2B848362FE32%7C20562653-A42D-4206-AFAB-7933D37ECF7D&format=json&loguid=&method=goods.view&nonce=1459051737&sessionid=1459051611&signmethod=md5&uuid=6c34fd8486aea35729d36d94864af09a&v=2&vc=47&vn=v6.1.0&GoodsId=4332&Latitude=34.618753&Longitude=112.426807" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        
        NSDictionary *result = dic[@"result"];
        NSArray *list = result[@"list"];
        for (NSDictionary *dic  in list) {
            TodayModel *model = [[TodayModel alloc] initWithNSDicetionary:dic];
            [self.ListArray addObject:model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark -------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    if (indexPath.row < self.ListArray.count) {
        cell.model = self.ListArray[indexPath.row];
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopViewController *shopVC = [[ShopViewController alloc] init];
//    TodayModel *model = self.ListArray[indexPath.row];
//    shopVC.title = model.title;
//    shopVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:shopVC animated:YES];
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 140;
        self.tableView.sectionIndexColor = [UIColor blackColor];
        
    }
    return _tableView;
}

- (NSMutableArray *)ListArray{
    if (_ListArray == nil) {
        _ListArray = [NSMutableArray new];
    }
    return _ListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
