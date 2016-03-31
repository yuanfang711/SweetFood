//
//  MianViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianViewController.h"
#import "MianTableViewCell.h"
#import "ChufangViewController.h"
#import "GoodReadController.h"
#import "ActivityViewController.h"
#import "HotThemeController.h"
#import "MainModel.h"
#import "MianModel.h"
#import "GoodModel.h"
#import "TodayViewController.h"
#import "SDCycleScrollView.h"
#import "ClassifyViewController.h"
@interface MianViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//tableview的头视图
@property (strong, nonatomic) UIView *headView;
@property (nonatomic, strong) UIButton *leftButton;

//数据 ：热门专辑
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *cellTwoArray;

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"菜谱";
    
    //设置tableView的头视图
    [self setTableViewHeadView];
    
    self.view.userInteractionEnabled  = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //请求数据
    [self getDataLoad];
    [self.view addSubview:self.tableView];

    //设置按钮
    //设置左导航栏
    self.leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame =CGRectMake(kScreenWitch - 60, 30, 60, 30);
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor redColor]];
    [self.leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}

- (void)leftBarButtonAction{
    ClassifyViewController *classVC = [[ClassifyViewController alloc] init];
    classVC.hidesBottomBarWhenPushed = YES;
    classVC.title = @"全部分类";
    [self.navigationController pushViewController:classVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.hidesBottomBarWhenPushed = NO;
}

#pragma mark ------------ 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    [manager GET:kMainDatd parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
 
        NSDictionary *event = result[@"recipe"];
        NSArray *listArray = event[@"list"];
        for (NSDictionary *listdic in listArray) {
            MainModel *model = [[MainModel alloc] initWithNSDictionary:listdic];
            [self.cellTwoArray  addObject:model];
        }
        NSDictionary *person = result[@"person"];
        NSArray *sonArray = person[@"tag"];
        for (NSDictionary *listdic in sonArray) {
            MianModel *model = [[MianModel alloc] initWithNSDictionary:listdic];
            [self.cellArray addObject:model];
        }
        [self.tableView reloadData];
        [self setTableViewHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark ********** 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    MianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell == nil) {
        cell = [[MianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstring];
    }
        if (indexPath.row < self.cellArray.count ) {
            MianModel*mainModel = self.cellArray[indexPath.row];
            cell.model = mainModel;
        }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        return @"猜你喜欢";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ChufangViewController *chuVC = [[ChufangViewController alloc] init];
        chuVC.modelNum = [NSNumber numberWithInt:1];
        MianModel *model = self.cellArray[indexPath.row];
        chuVC.title = model.title;
        chuVC.modelId = model.cateId;
        chuVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chuVC animated:YES];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MainModel *model= self.cellTwoArray[index];
    NSString *idstring = model.url;
    NSArray *idarray = [idstring componentsSeparatedByString:@"com/"];
    NSString *com = idarray[1];
    NSArray *celltype = [com componentsSeparatedByString:@"/"];
    if (celltype.count == 2) {
        NSString *url = celltype[celltype.count - 1];
        NSArray *homeurl = [url componentsSeparatedByString:@"url="];
        NSString *Homeurl = homeurl[1];
        NSArray *htmlurl = [Homeurl componentsSeparatedByString:@"%2F"];
        
        HotThemeController *hotVC = [[HotThemeController alloc] init];
        if ([celltype[0]isEqualToString:@"openurl"]) {
            hotVC.htmlUrl = [NSString stringWithFormat:@"http://%@/%@",htmlurl[htmlurl.count - 2],htmlurl[htmlurl.count - 1]];
        }
        if ([celltype[0]isEqualToString:@"opentopic"]) {
            NSString *homlid = htmlurl[htmlurl.count - 1];
            NSArray *htmlid = [homlid componentsSeparatedByString:@"&id"];
            hotVC.htmlUrl = [NSString stringWithFormat:@"http://%@/%@?_v=nohead",htmlurl[htmlurl.count - 2],htmlid[0]];
        }
        
        hotVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotVC animated:YES];
        
    }else{
        NSString *main = celltype[2];
        NSArray *mainarray = [main componentsSeparatedByString:@"="];
        NSString *mainID = mainarray[1];
        if ([celltype[0] isEqualToString:@"goods"]) {
            TodayViewController *todaVC = [[TodayViewController alloc] init];
            
            todaVC.todayId = mainID;
            todaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:todaVC animated:YES];
        }if([celltype[0] isEqualToString:@"recipe"]){
            ActivityViewController *actiVC = [[ActivityViewController alloc ]init];
            actiVC.fooDid = mainID;
            actiVC.title = model.title;
            [self.navigationController pushViewController:actiVC animated:YES];
        }
        
        if([celltype[0] isEqualToString:@"collect"]){
            GoodReadController *GoodVC = [[GoodReadController alloc] init];
            GoodVC.goodId = mainID;
            GoodVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:GoodVC animated:YES];
        }
    }
}

#pragma mark -----------  设置区头
- (void)setTableViewHeadView{
//    self.headView.backgroundColor = kViewColor;
    UIScrollView  *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/3)];
    scrollView.contentSize = CGSizeMake(kScreenWitch, kScreenhight / 3);
    NSMutableArray *group = [NSMutableArray new];
    NSMutableArray *titleGroup = [NSMutableArray new];
    for (int i = 0;i < self.cellTwoArray.count; i++) {
        MainModel *model = self.cellTwoArray[i];
        NSString *url =model.icon;
        NSString *titile = model.title;
        [group addObject:url];
        [titleGroup addObject:titile];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 5, kScreenWitch,kScreenhight/3) shouldInfiniteLoop:YES imageNamesGroup:group];
    cycleScrollView.delegate = self;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.titlesGroup = titleGroup;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    //轮播时间，默认1秒
    cycleScrollView.autoScrollTimeInterval = 3.0;
    [scrollView addSubview:cycleScrollView];
    [self.headView addSubview:scrollView];
    self.tableView.tableHeaderView = self.headView;
}
#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];

        self.tableView.rowHeight = 210;
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch-10, kScreenhight / 3)];
    }
    return _headView;
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
