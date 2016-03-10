//
//  HomeViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "TodayViewController.h"
#import "HotThemeController.h"
#import "GoodReadController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

//区头视图
@property (nonatomic, strong) UIView *headView;
//今日特价
@property (nonatomic, strong) UIView *todayView;
//故事
@property (nonatomic, strong) UIView *storyView;

//cell数据
@property (nonatomic, strong) NSMutableArray *homeArray;

//品牌
@property (nonatomic, strong) NSMutableArray *storyArray;

//今日特价
@property (nonatomic, strong) NSMutableArray *tadayArray;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"到家";
    
    
    //    self.tableView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.tableView];
    
    [self settingHeadCell];
    
    [self getHomeData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

- (void)getHomeData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    [manager GET:kHomeData parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];

        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        NSArray *listArray = result[@"list"];
        
        
        for (NSDictionary *listDic in listArray) {
            HomeModel *model = [[HomeModel alloc] initWithNSDictionary:listDic];
            [self.homeArray addObject:model];
        }
        
        //        NSDictionary *taody = result[@"DailySpecialGoods"];
        //        self.tadayArray = taody[@"CoverUrl"];
        
        NSDictionary *stoay = result[@"DailySpecialGoods"];
        [self.storyArray addObject:stoay];
        //
        [self.tableView reloadData];
        [self settingHeadCell];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];

        NSLog(@"%@",error);
    }];
}
#pragma mark ----------- 设置区头
- (void)settingHeadCell{
    self.headView.frame = CGRectMake(5, 5, kScreenWitch - 10, 110);
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, kScreenWitch/2 - 10, 110)];
    for (int i = 0; i < self.storyArray.count; i++) {
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.storyArray[i][@"CoverUrl"]] placeholderImage:nil];
    }
    UILabel *teLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    teLable.backgroundColor = [UIColor redColor];
    teLable.text = @"今日特价";
    teLable.textColor = [UIColor whiteColor];
    teLable.numberOfLines = 0;
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWitch/2 + 5, 0, kScreenWitch/2 - 10, 110)];
    
    [rightView sd_setImageWithURL:[NSURL URLWithString:@"http://img1.hoto.cn/mall/mall_ad/2016/03/1456913591.jpg"] placeholderImage:nil];
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeSystem];
    iconButton.frame = self.headView.frame;
    [iconView addSubview:teLable];
    [iconButton addSubview:iconView];
    [iconButton addTarget:self action:@selector(todayAction) forControlEvents:UIControlEventTouchUpInside];
    [iconButton addSubview:rightView];
    [self.headView addSubview:iconButton];
    self.tableView.tableHeaderView = self.headView;
}
- (void)todayAction{
    TodayViewController *todaVC = [[TodayViewController alloc] init];
    todaVC.todayId = @"173";
    todaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:todaVC animated:YES];
}
#pragma mark ----------- 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell== nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    
    if (indexPath.row < self.homeArray.count) {
        cell.model =self.homeArray[indexPath.row];
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodReadController *goodVC = [[GoodReadController alloc] init];
    goodVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodVC animated:YES];
}

#pragma mark --------- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor brownColor];
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

-(UIView *)todayView{
    if (_todayView == nil) {
        _todayView = [[UIView alloc] init];
    }
    return _todayView;
}

-(UIView *)storyView{
    if (_storyView == nil) {
        _storyView = [[UIView alloc] init];
    }
    return _storyView;
}
- (NSMutableArray *)homeArray{
    if (_homeArray == nil) {
        _homeArray = [NSMutableArray new];
    }
    return _homeArray;
}
- (NSMutableArray *)tadayArray{
    if (_tadayArray == nil) {
        _tadayArray = [NSMutableArray new];
    }
    return _tadayArray;
}
- (NSMutableArray *)storyArray{
    if (_storyArray == nil) {
        _storyArray = [NSMutableArray new];
    }
    return _storyArray;
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
