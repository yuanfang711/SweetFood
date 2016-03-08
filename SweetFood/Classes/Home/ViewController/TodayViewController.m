//
//  TodayViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//
/*
 http://api.haodou.com/mall/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1457322096694&vc=83&vn=6.1.0&loguid=0&deviceid=haodou866656021957511&uuid=e6cbc5ed186438c278364ed41078a110&channel=huawei_v610&method=collect.goodslist&virtual=&signmethod=md5&v=2&timestamp=1457322137&nonce=0.907562864652508&appsign=c378312a8d54542f3a00db6978c7af08
 */
#import "TodayViewController.h"
#import "TodayTableViewCell.h"
#import "TodayModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>


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


#pragma mark -------- 请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    [manager GET:kToday parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
    
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 130;
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
