//
//  MovieViewController.m
//  视屏
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MovieViewController.h"
#import "SDCycleScrollView.h"
#import "MovieMainTableViewCell.h"
#import "StoryViewController.h"
#import "GoodReadController.h"
#import "ColleMovieVController.h"
#import "HotViewController.h"
#import "HomeModel.h"
#import "ProgressHUD.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface MovieViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableViwe;
@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) NSString *name;
@end
@implementation MovieViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableViwe];
    //注册cell
    [self.tableViwe registerNib:[UINib nibWithNibName:@"MovieMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self getDateload];
    [self getClassDateload];
    //黑背景
    self.blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];
    self.blankView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:29.0/255.0 blue:29.0/255.0 alpha:0.6];
    self.blankView.hidden = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.blankView.frame;
    [button addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.blankView addSubview:button];
    [self.view addSubview:self.blankView];

    //设置左导航栏
    self.leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame =CGRectMake(kScreenWitch - 60, 30, 60, 30);
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.leftButton setTitle:@"热门分类" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor redColor]];
    [self.leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    
}
- (void)backView{
    self.blankView.hidden = YES;
    
}
- (void)leftBarButtonAction{
    self.blankView.hidden = NO;
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, self.classArray.count* kScreenhight/25/3)];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWitch, self.classArray.count* kScreenhight/25/3);
    [white addSubview:self.collectionView];
    [self.blankView addSubview:white];
}
#pragma mark ---------- 数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    [manager GET:kMovie parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        self.result = dic[@"result"];
        NSArray *array = self.result[@"ad"];
        for (NSDictionary *dics in array) {
            [self.adArray addObject:dics];
        }
        NSArray *group = self.result[@"hotrank"];
        for (NSDictionary *dics in group) {
            HomeModel *model = [[HomeModel alloc] initWithNSDictionary:dics[@"Info"]];
            [self.hotArray  addObject:model];
        }
        NSArray *group2 = self.result[@"recipe"];
        for (NSDictionary *dics in group2) {
            HomeModel *model = [[HomeModel alloc] initWithNSDictionary:dics[@"Info"]];
            [self.menuArray addObject:model];
        }
        NSArray *group3 = self.result[@"novice"];
        for (NSDictionary *dics in group3) {
            HomeModel *model = [[HomeModel alloc] initWithNSDictionary:dics[@"Info"]];
            [self.newArray addObject:model];
        }
        [self.tableViwe reloadData];
        [self setTingHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}
- (void)viewDidDisappear:(BOOL)animated{
    self.blankView.hidden = YES;
}
- (void)getClassDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:@"http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=e98db2e630829e7795965274e5b205b8&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C2F8CCE8D-7B19-4DFD-BA50-2B848362FE32%7C20562653-A42D-4206-AFAB-7933D37ECF7D&format=json&loguid=&method=Video.getRecipeVideoCateList&nonce=1459076812&sessionid=1459051611&signmethod=md5&uuid=6c34fd8486aea35729d36d94864af09a&v=2&vc=47&vn=v6.1.0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *results = dic[@"result"];
        NSArray *array = results[@"list"];
        for (NSDictionary *dics in array) {
            [self.classArray addObject:dics];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)setTingHeadView{
    if (self.adArray.count > 0) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/4)];
        scrollView.contentSize = CGSizeMake(kScreenWitch, kScreenhight/4);
        NSMutableArray *group = [NSMutableArray new];
        for (NSDictionary *dic in self.adArray) {
            NSString *url = dic[@"ImgUrl"];
            [group addObject:url];
        }
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 0,kScreenWitch, kScreenhight/4) shouldInfiniteLoop:YES imageNamesGroup:group];
        cycleScrollView.delegate = self;
        cycleScrollView.backgroundColor = [UIColor whiteColor];
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        //轮播时间，默认1秒
        cycleScrollView.autoScrollTimeInterval = 2.0;
        [scrollView addSubview:cycleScrollView];
        [self.headView addSubview:scrollView];
    }
}
#pragma mark ------------- 分类代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cellCollection = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellCollection.frame.size.width  , cellCollection.frame.size.height)];
    title.backgroundColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.classArray[indexPath.row][@"CateName"];
    cellCollection.backgroundColor = [UIColor whiteColor];
    [cellCollection addSubview:title];
    return cellCollection;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ColleMovieVController *colleVC = [[ColleMovieVController alloc] init];
    colleVC.title = self.classArray[indexPath.row][@"CateName"];
    colleVC.videoId = self.classArray[indexPath.row][@"CateId"];
    colleVC.type = @"2";
    colleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:colleVC animated:YES];
}
#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.hotArray[indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.model = self.menuArray[indexPath.row];
    }
    if (indexPath.section == 2) {
        cell.model = self.newArray[indexPath.row];
    }
    cell.contentView.backgroundColor = kViewColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.hotArray.count;
    }
    if (section == 1) {
        return  self.menuArray.count;
    }
    if (section == 2) {
        return  self.newArray.count;
    }
    else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWitch, 30)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWitch / 2, 30)];
    label.textColor = [UIColor orangeColor];
    if (section == 0) {
        label.text = @"热门排行榜";
    }
    if (section == 1) {
        label.text = @"视频菜谱";
    }
    if (section == 2) {
        label.text = @"新手课堂";
    }
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWitch - 30, 8, 20, 20);
    [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
- (void)cellButtonAction:(UIButton *)button{
    if (button.tag == 0) {
        HotViewController *hotVC = [[HotViewController alloc] init];
        hotVC.title = @"热门排行榜";
        hotVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotVC animated:YES];
    }
    if (button.tag == 1) {
        ColleMovieVController *colleVC = [[ColleMovieVController alloc] init];
        colleVC.title = @"视频菜谱";
        colleVC.type = @"0";
        colleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:colleVC animated:YES];
    }
    if (button.tag == 2) {
        ColleMovieVController *colleVC = [[ColleMovieVController alloc] init];
        colleVC.title = @"新手课堂";
        colleVC.type = @"1";
        
        colleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:colleVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    CGFloat sectionHeaderHeight = 35;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryViewController *storyVC = [[StoryViewController alloc] init];
    if (indexPath.section == 0) {
        HomeModel *model = self.hotArray[indexPath.row];
        storyVC.videoId = model.movieId;
    }
    if (indexPath.section == 1) {
        HomeModel *model = self.menuArray[indexPath.row];
        storyVC.videoId = model.movieId;
    }
    if (indexPath.section == 2) {
        HomeModel *model = self.newArray[indexPath.row];
        storyVC.videoId = model.movieId;
    }
    [self.navigationController pushViewController:storyVC animated:YES];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    GoodReadController *GoodVC = [[GoodReadController alloc] init];
    NSString *sting = self.adArray[index][@"Url"];
    NSArray *rray = [sting componentsSeparatedByString:@"id="];
    GoodVC.goodId = rray[1];
    GoodVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:GoodVC animated:YES];
}

#pragma mark ---------- 懒加载
-(UITableView *)tableViwe{
    if (_tableViwe == nil) {
        self.tableViwe = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight-104) style:UITableViewStylePlain];
        self.tableViwe.dataSource = self;
        self.tableViwe.delegate = self;
        self.tableViwe.rowHeight = kScreenhight/3+30;
        self.tableViwe.tableHeaderView = self.headView;
    }
    return _tableViwe;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.001;
        //每一行的间距
        layout.minimumLineSpacing = 2;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/4-2 ,kScreenhight/20);
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWitch, kScreenhight-100) collectionViewLayout:layout];
        //设置代理
       self.collectionView.delegate = self;
       self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        //注册item类型，与下item的设置要一致
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}


- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/4)];
    }
    return _headView;
}
- (NSDictionary *)result{
    if (_result == nil) {
        self.result = [NSDictionary new];
    }
    return _result;
}

- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        self.hotArray = [NSMutableArray new];
    }
    return _hotArray;
}
- (NSMutableArray *)menuArray{
    if (_menuArray == nil) {
        self.menuArray = [NSMutableArray new];
    }
    return _menuArray;
}
- (NSMutableArray *)newArray{
    if (_newArray == nil) {
        self.newArray = [NSMutableArray new];
    }
    return _newArray;
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}
- (NSMutableArray *)classArray{
    if (_classArray == nil) {
        self.classArray = [NSMutableArray new];
    }
    return _classArray;
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
