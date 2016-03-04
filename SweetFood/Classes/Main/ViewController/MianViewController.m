//
//  MianViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianViewController.h"
#import "MianTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define kScreenWitch [UIScreen mainScreen].bounds.size.width
#define kScreenhight [UIScreen mainScreen].bounds.size.height

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

//数据 ：热门专辑
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *NewArray;
@property (nonatomic, strong) NSMutableArray *cellTwoArray;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    
    //    //注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"MianTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //
    
    [self.headScrollView addSubview:self.pageC];
    //设置tableView的头视图
    [self setTableViewHeadView];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //请求数据
    [self getDataLoad];
    [self.view addSubview:self.tableView];
}

- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:@"http://api.haodou.com/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1456977770070&vc=83&vn=6.1.0&loguid=0&deviceid=haodou866656021957511&uuid=e6cbc5ed186438c278364ed41078a110&channel=huawei_v610&method=Index.index" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        
        //        NSString *AB = rootDic[@"_AB"];
        //        NSString *status = rootDic[@"status"];
        //        NSString *request_id = rootDic[@"request_id"];
        //        if ([AB isEqualToString:@"ABTESTING_RECOMMEND_RECIPE:A"] && [status intValue]== 0 && [request_id isEqualToString:@"f668876840ba90745a42e4dc44e7940b"]) {
        NSDictionary *result = rootDic[@"result"];
        //广告数据
        
        
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
            //                [model setValuesForKeysWithDictionary:listdic];
            
            [self.cellTwoArray  addObject:model];
        }
        [self.listArray addObject:self.cellTwoArray];
        
        //        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark ********** 代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    static NSString *cellString = @"ghjk";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];
//    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row < self.listArray.count) {
        NSMutableArray *group = self.listArray[indexPath.section];
        cell.model = group[indexPath.row];
        
    }
    
    
    //    if (indexPath.section == 0) {
    //        if (indexPath.row < self.cellArray.count) {
    //            cell.model = self.cellArray[indexPath.row];
    //        }
    //    }
    //    if (indexPath.section == 1) {
    //        if (indexPath.row < self.cellTwoArray.count) {
    //            cell.model = self.cellTwoArray[indexPath.row];
    //        }
    //    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    //    if (section == 0) {
//    return @"精品阅读";
//    //    }else
//    //        return @"热门活动";
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 340;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -----------  设置区头
- (void)setTableViewHeadView{
    self.headView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.5];
    //列表
    [self toolViewChange];
    //热门专辑
    [self hotTheme];
    
    //打开用户交互
    self.headView.userInteractionEnabled = YES;
    
    [self.headView addSubview:self.headScrollView];
    [self.headView addSubview:self.toolView];
    [self.headView addSubview:self.hotView];
    self.tableView.tableHeaderView = self.headView;
}
//列表内容
- (void)toolViewChange{
    //列表
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(5, 3, kScreenWitch / 3 - 10, 55);
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
    left.frame = CGRectMake(5, 35, kScreenWitch /2 - 5, 98);
    [left setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(kScreenWitch /2 + 5, 35, kScreenWitch /2 - 10, 98);
    [right setImage:[UIImage imageNamed:@"you.png"] forState:UIControlStateNormal];
    [self.hotView addSubview:title];
    [self.hotView addSubview:left];
    [self.hotView addSubview:right];
}
#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight -44)];
        self.tableView.separatorColor = [UIColor brownColor];
        
        self.tableView.rowHeight = 125;
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

- (UIPageControl *)pageC{
    if (_pageC == nil) {
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, kScreenWitch, 20)];
        self.pageC.numberOfPages = 8;
        self.pageC.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageC addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageC;
}
- (UIScrollView *)headScrollView{
    if (_headScrollView == nil) {
        _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 150)];
        self.headScrollView.bounces = NO;
        self.headScrollView.delegate = self;
        self.headScrollView.showsHorizontalScrollIndicator = NO;
        self.headScrollView.contentSize = CGSizeMake(kScreenWitch * 8, 150);
        self.headScrollView.backgroundColor = [UIColor grayColor];
        self.headScrollView.scrollEnabled = YES;
    }
    return _headScrollView;
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
        //        _hotView.backgroundColor = [UIColor magentaColor];
        
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
