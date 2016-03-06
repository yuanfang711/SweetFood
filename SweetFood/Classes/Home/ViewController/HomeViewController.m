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
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *homeArray;


//区头视图
@property (nonatomic, strong) UIView *headView;
//今日特价
@property (nonatomic, strong) UIView *todayView;
//故事
@property (nonatomic, strong) UIView *storyView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"到家";
    
    
    self.tableView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.tableView];
    
    [self settingHeadCell];
    
    [self getHomeData];
}
- (void)getHomeData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:kHomeData parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        NSArray *adArray = result[@"list"];
        NSMutableArray *groupNew = [NSMutableArray new];
        for (NSDictionary *listDic in adArray) {
            HomeModel *model = [[HomeModel alloc] initWithNSDictionary:listDic];
            [groupNew addObject:model];
        }
        [self.homeArray addObject:groupNew];
        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark ----------- 设置区头
- (void)settingHeadCell{
    self.headView.frame = CGRectMake(0, 0, kScreenWitch, 260);
    
    //今日特价
    self.todayView.frame = CGRectMake(0, 5, kScreenWitch, 100);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, kScreenWitch - 80, 100)];
    
    iconView.backgroundColor = kViewColor;
    [self.todayView addSubview:iconView];
    
    UILabel *teLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 15, 100)];
    teLable.text = @"今日特价";
    teLable.numberOfLines = 0;
    [self.todayView addSubview:teLable];
    
    //品牌故事
    self.storyView.frame = CGRectMake(0, 110, kScreenWitch, 150);
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 120, 25)];
    titleLable.text = @"品牌故事";
    [self.storyView addSubview:titleLable];
    
    UIImageView *guView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 31, kScreenWitch - 10, 119)];
    
    guView.backgroundColor = kViewColor;
    [self.storyView addSubview:guView];
    [self.headView addSubview:self.todayView];
    [self.headView addSubview:self.storyView];
    self.tableView.tableHeaderView = self.headView;
}
#pragma mark ----------- 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.listArray.count;
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell== nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    
//    cell.model = self.homeArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}
#pragma mark --------- 懒加载
- (NSMutableArray *)homeArray{
    if (_homeArray == nil) {
        _homeArray = [NSMutableArray new];
    }
    return _homeArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight-44)];
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
/*http://m.haodou.com/topic-427660.html?_v=nohead&store_id=4017*/
-(UIView *)storyView{
    if (_storyView == nil) {
        _storyView = [[UIView alloc] init];
    }
    return _storyView;
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
