//
//  MianViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianViewController.h"
#import "MianTableViewCell.h"
#import "HotThemeController.h"
#import "HomeViewController.h"
#import "WorkViewController.h"
#import "ChufangViewController.h"
#import "GoodReadController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MianViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//tableview的头视图
@property (strong, nonatomic) UIView *headView;
//广告的滚动视图
@property (strong, nonatomic) UIScrollView *headScrollView;
//列表视图
@property (strong, nonatomic) UIView *toolView;
//热门专辑视图
@property (strong, nonatomic) UIView *hotView;
//页
@property (nonatomic, strong) UIPageControl *pageC;
@property (nonatomic, strong) UIImageView *scrollView;

//数据 ：热门专辑
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *NewArray;
@property (nonatomic, strong) NSMutableArray *cellTwoArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *hotArray;
@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MianTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.headScrollView addSubview:self.pageC];
    //设置tableView的头视图
    [self setTableViewHeadView];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //请求数据
    [self getDataLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark ------------ 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:kMainDatd parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //广告数据
        NSDictionary *recipeDic = result[@"recipe"];
        NSArray *adArray = recipeDic[@"list"];
        NSMutableArray *groupNew = [NSMutableArray new];
        for (NSDictionary *listDic in adArray) {
            [groupNew addObject:listDic];
        }
        [self.NewArray addObject:groupNew];
        
        //热门专辑
        NSDictionary *alDic = result[@"album"];
        NSArray *alArray = alDic[@"list"];
        NSMutableArray *groupAlbum = [NSMutableArray new];
        for (NSDictionary *listDic in alArray) {
            MianModel *model = [[MianModel alloc] initWithNSDictionary:listDic];
            [groupAlbum addObject:model];
        }
        [self.hotArray addObject:groupAlbum];
        
        //table数据
        NSDictionary *read = result[@"read"];
        NSArray *raedArray = read[@"list"];
        for (NSDictionary *listdic in raedArray) {
            MianModel *model = [[MianModel alloc] initWithNSDictionary:listdic];
            [self.cellArray addObject:model];
        }
        [self.listArray addObject:self.cellArray];
        
        NSDictionary *event = result[@"event"];
        NSArray *listArray = event[@"list"];
        for (NSDictionary *listdic in listArray) {
            MianModel *model = [[MianModel alloc] initWithNSDictionary:listdic];
            [self.cellTwoArray  addObject:model];
        }
        [self.listArray addObject:self.cellTwoArray];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark ********** 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSMutableArray *group = self.listArray[indexPath.section];
    if (indexPath.row < group.count) {
        cell.model = group[indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *group = self.listArray[section];
    return group.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"精品阅读";
    }else
        return @"热门活动";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            GoodReadController *goodVC = [[GoodReadController alloc] init];
            goodVC.navigationController.title = @"精品活动";
            [self.navigationController pushViewController:goodVC animated:YES];
        }else{
            HotThemeController *hotvc = [[HotThemeController alloc] init];
            hotvc.navigationController.title = @"热门活动";
            [self.navigationController pushViewController:hotvc animated:YES];}
    }
    if (indexPath.section == 1) {
        HotThemeController *hotvc = [[HotThemeController alloc] init];
        hotvc.navigationController.title = @"热门活动";
        [self.navigationController pushViewController:hotvc animated:YES];
    }
}
#pragma mark -----------  设置区头
- (void)setTableViewHeadView{
    self.headView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.5];
    //广告轮播图
    self.scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView.frame = CGRectMake(0, 0, kScreenhight, 150);
    for (int i = 0; i < self.NewArray.count; i ++) {
        [self.scrollView sd_setImageWithURL:[NSURL URLWithString:self.NewArray[i][@"Img"]] placeholderImage:nil];
    }
    
    [self.headScrollView addSubview:self.scrollView];
    [self.headView addSubview:self.headScrollView];
    
    //列表
    [self toolViewChange];
    //热门专辑
    [self hotTheme];
    
    //打开用户交互
    self.headView.userInteractionEnabled = YES;

    [self.headView addSubview:self.toolView];
    [self.headView addSubview:self.hotView];
    self.tableView.tableHeaderView = self.headView;
}
//列表内容
- (void)toolViewChange{
    //列表
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(5, 3, kScreenWitch / 3 - 10, 55);
    [foodButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    foodButton.tag = 100;
    UIImageView *food = [[UIImageView alloc] initWithFrame:CGRectMake(foodButton.frame.size.width/3 - 5, 0, foodButton.frame.size.width/3 + 10, 35)];
    food.image = [UIImage imageNamed:@"meishi.png"];
    UILabel *foodLable = [[UILabel alloc] initWithFrame:CGRectMake(foodButton.frame.size.width/3 - 5, 35, foodButton.frame.size.width/3 + 10, 20)];
    foodLable.text = @"美食汇";
    foodLable.textColor = [UIColor greenColor];
    foodLable.textAlignment = NSTextAlignmentCenter;
    foodLable.font = [UIFont systemFontOfSize:13.0];
    [foodButton addSubview:food];
    [foodButton addSubview:foodLable];
    
    UIButton *workButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workButton.frame = CGRectMake(kScreenWitch / 3 + 5, 3, kScreenWitch / 3 - 10 , 55);
    [workButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    workButton.tag = 101;
    UIImageView *work = [[UIImageView alloc] initWithFrame:CGRectMake(workButton.frame.size.width/3 - 5, 0, workButton.frame.size.width/3 + 10, 35)];
    work.image = [UIImage imageNamed:@"xiangji.png"];
    UILabel *workLable = [[UILabel alloc] initWithFrame:CGRectMake(workButton.frame.size.width/3 - 5, 35, workButton.frame.size.width/3 + 10, 20)];
    workLable.text = @"晒作品";
    workLable.textColor = [UIColor orangeColor];
    workLable.textAlignment = NSTextAlignmentCenter;
    workLable.font = [UIFont systemFontOfSize:13.0];
    [workButton addSubview:work];
    [workButton addSubview:workLable];
    
    
    UIButton *chuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chuButton.frame = CGRectMake(kScreenWitch / 3 * 2 + 5, 3, kScreenWitch / 3  - 10, 55);
    [chuButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    chuButton.tag = 102;
    UIImageView *chu = [[UIImageView alloc] initWithFrame:CGRectMake(chuButton.frame.size.width/3 - 5, 0, chuButton.frame.size.width/3 + 10, 35)];
    chu.image = [UIImage imageNamed:@"chufang.png"];
    UILabel *chuLable = [[UILabel alloc] initWithFrame:CGRectMake(chuButton.frame.size.width/3 - 5, 35, chuButton.frame.size.width/3 + 10, 20)];
    chuLable.text = @"厨房宝典";
    chuLable.textColor = [UIColor magentaColor];
    chuLable.textAlignment = NSTextAlignmentCenter;
    chuLable.font = [UIFont systemFontOfSize:12.0];
    [chuButton addSubview:chu];
    [chuButton addSubview:chuLable];
    
    [self.toolView addSubview:foodButton];
    [self.toolView addSubview:workButton];
    [self.toolView addSubview:chuButton];
}
//热门专辑
- (void)hotTheme{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kScreenWitch - 20, 20)];
    title.text = @"热门专辑";
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(15, 35, kScreenWitch /2 - 15, 98);
    [left addTarget:self action:@selector(zhuanjiAction) forControlEvents:UIControlEventTouchUpInside];
    left.tag = 0;
    [left setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(kScreenWitch /2 + 10, 35, kScreenWitch /2 - 25, 98);
    [right addTarget:self action:@selector(zhuanjiAction) forControlEvents:UIControlEventTouchUpInside];
    right.tag = 1;
    [right setImage:[UIImage imageNamed:@"you.png"] forState:UIControlStateNormal];
    [self.hotView addSubview:title];
    [self.hotView addSubview:left];
    [self.hotView addSubview:right];
}

#pragma mark -------- 点击方法
- (void)toolAction:(UIButton *)button{
    if (button.tag == 100) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"HomaVC" bundle:nil];
        HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomaVC"];
        [self.navigationController pushViewController:homeVC animated:YES];
    }
    if (button.tag == 101) {
        WorkViewController *workVC = [[WorkViewController alloc] init];
        [self.navigationController pushViewController:workVC animated:YES];
    }
    if (button.tag == 102) {
        ChufangViewController *chuVC = [[ChufangViewController alloc] init];
        
        [self.navigationController pushViewController:chuVC animated:YES];
    }
}
- (void)zhuanjiAction{
    HotThemeController *hotVC = [[HotThemeController alloc] init];
    //    hotVC.title = self.hotArray[@"Title"];
    
    [self.navigationController pushViewController:hotVC animated:YES];
}
#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight -44)];
        self.tableView.separatorColor = [UIColor brownColor];
        
        self.tableView.rowHeight = 115;
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 340)];
        self.headView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return _headView;
}

- (UIScrollView *)headScrollView{
    if (_headScrollView == nil) {
        _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 150)];
        //划到边界，不在动
        self.headScrollView.bounces = NO;
        self.headScrollView.delegate = self;
        //是否显示水平条
        self.headScrollView.showsHorizontalScrollIndicator = NO;
        //内容大小
        self.headScrollView.contentSize = CGSizeMake(kScreenWitch * self.NewArray.count, 150);
        //整屏滑动
        self.headScrollView.pagingEnabled = YES;
        self.headScrollView.backgroundColor = [UIColor grayColor];
        self.headScrollView.scrollEnabled = YES;
    }
    return _headScrollView;
}
- (UIPageControl *)pageC{
    if (_pageC == nil) {
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, kScreenWitch, 20)];
        self.pageC.numberOfPages = self.NewArray.count;
        self.pageC.currentPage = 0;
        self.pageC.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageC addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageC;
}
- (UIImageView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIImageView alloc] init];
        
    }
    return _scrollView;
}

- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 152, kScreenWitch, 55)];
        self.toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}
- (UIView *)hotView{
    if (_hotView == nil) {
        _hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 210, kScreenWitch, 125)];
    }
    return _hotView;
}
- (NSMutableArray *)NewArray{
    if (_NewArray == nil) {
        _NewArray = [NSMutableArray new];
    }
    return _NewArray;
}
- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
}
- (NSMutableArray *)cellTwoArray{
    if (_cellTwoArray == nil) {
        _cellTwoArray = [NSMutableArray new];
    }
    return _cellTwoArray;
}
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        self.hotArray = [NSMutableArray new];
    }
    return _hotArray;
}
- (void)pageAction{
    
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
