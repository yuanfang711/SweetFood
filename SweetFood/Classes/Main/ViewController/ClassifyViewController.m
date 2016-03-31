//
//  ClassifyViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassTableViewCell.h"
#import "ChufangViewController.h"
@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger Number;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) UIView *blackView;
@end

static NSString *cellSting = @"title";
static NSString *collections = @"collection";
@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self showBackButtonWithImage:@"back"];
    [self.view addSubview:self.collectionView];
    Number = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:cellSting];
    [self getTitleData];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    
    self.navigationItem.rightBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.8];
    //    self.tableView.hidden = YES;
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];
    self.blackView.hidden = YES;
    [self.view addSubview:self.blackView];
}
- (void)leftBarButtonAction{
    self.blackView.hidden = NO;
    [self.blackView addSubview:self.tableView];

}

#pragma mark -----------数据请求
- (void)getTitleData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    [manager GET:@"http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=c2dc6c7bda07b4a2395cbef003746fcc&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C2F8CCE8D-7B19-4DFD-BA50-2B848362FE32%7C20562653-A42D-4206-AFAB-7933D37ECF7D&format=json&loguid=&method=Search.getcatelist&nonce=1459076470&sessionid=1459051611&signmethod=md5&uuid=6c34fd8486aea35729d36d94864af09a&v=2&vc=47&vn=v6.1.0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        NSArray *liset = result[@"list"];
        if (self.titleArray.count > 0) {
            [self.titleArray removeAllObjects];
        }
        for (NSDictionary *dic in liset) {
            [self.titleArray addObject:dic];
        }
        if (self.classArray.count > 0) {
            [self.classArray removeAllObjects];
        }
        NSArray *tage = self.titleArray[Number][@"Tags"];
        for (NSDictionary *dic in tage) {
            [self.classArray addObject:dic];
        }
        [self.tableView reloadData];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
#pragma mark -----------UICollectionView代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:collections forIndexPath:indexPath];
    for (UIView *view in cells.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cells.frame.size.width - 5,cells.frame.size.height - 5)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cells.frame.size.width - 5,cells.frame.size.height - 5)];
    title.font = [UIFont systemFontOfSize:15.0];
    title.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    title.layer.cornerRadius = 8;
    title.layer.masksToBounds = YES;
    title.text = self.classArray[indexPath.row][@"Name"];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [cells.contentView addSubview:view];
    return cells;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChufangViewController *chuVC = [[ChufangViewController alloc] init];
    chuVC.modelNum = [NSNumber numberWithInt:1];
    chuVC.title = self.classArray[indexPath.row][@"Name"];
    chuVC.modelId = self.classArray[indexPath.row][@"Id"];
;
    chuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chuVC animated:YES];
}

#pragma mark -----------UITableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSting forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.titleLable.text = self.titleArray[indexPath.row][@"Cate"];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Number = indexPath.row;
    self.title = self.titleArray[Number][@"Cate"];
    [self getTitleData];
    self.blackView.hidden = YES;
}

#pragma mark -----------懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.01;
        //每一行的间距
        layout.minimumLineSpacing = 1;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/3-1 ,kScreenhight/20);
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册item类型，与下item的设置要一致
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collections];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWitch - kScreenWitch/4, 64, kScreenWitch/4, kScreenhight-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 44;
        self.tableView.separatorColor = [UIColor grayColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
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
