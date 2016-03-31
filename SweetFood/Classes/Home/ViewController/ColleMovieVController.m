//
//  ColleMovieVController.m
//  SweetFood
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ColleMovieVController.h"
#import "MovieModel.h"
#import "ActivityViewController.h"
#import "LoveModel.h"
#import "StrollViewController.h"
#import "StoryViewController.h"
#import "MJRefresh.h"

static NSString *cellString = @"iOS";
@interface ColleMovieVController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>{
    NSInteger _offset;
    BOOL _isRefresh;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *CateArray;
@property (nonatomic, strong) NSMutableArray *VideoArray;
@property (nonatomic, strong) NSMutableArray *NewArray;
@property (nonatomic, strong) NSMutableArray *classArray;
@end

@implementation ColleMovieVController

- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;
    [self showBackButtonWithImage:@"back"];
    if ([self.type isEqualToString:@"0"]) {
        [self getDateload];
    }
    if ([self.type isEqualToString:@"1"]) {
        [self getNewDateload];
    }
    if ([self.type isEqualToString:@"2"]) {
        [self getDatesload];
    }
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        [self.collectionView.mj_header beginRefreshing];
        _offset = 0;
        _isRefresh = YES;
        if ([self.type isEqualToString:@"1"]) {
            [self getNewDateload];
        }
        if ([self.type isEqualToString:@"2"]) {
            [self getDatesload];
        }
        [self.collectionView.mj_header endRefreshing];
      
    }];
    
      //加载
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer beginRefreshing ];
        _offset += 20;
        _isRefresh = NO;
        if ([self.type isEqualToString:@"1"]) {
            [self getNewDateload];
        }
        if ([self.
             type isEqualToString:@"2"]) {
            [self getDatesload];
        }
        //刷新结束
        [self.collectionView.mj_footer endRefreshing];
    }];
  
    [self.view addSubview:self.collectionView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
#pragma mark -------- 请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    [manager GET:kMovieData parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *cateList = result[@"CateList"];
        for (NSDictionary *listDic in cateList) {
            [self.CateArray addObject:listDic];
        }
        NSArray *video = result[@"VideoList"];
        for (NSDictionary *listDic in video) {
            NSArray *array = listDic[@"List"];
            [self.VideoArray addObject:array];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}
- (void)getNewDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    NSString *string = @"http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=6bb6c80200eb8cc4f1038eeac145fd45&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C2F8CCE8D-7B19-4DFD-BA50-2B848362FE32%7C20562653-A42D-4206-AFAB-7933D37ECF7D&format=json&loguid=&method=Video.getNoviceVideoList%20&nonce=1459401436&sessionid=1459401425&signmethod=md5&timestamp=1459401436&uuid=6c34fd8486aea35729d36d94864af09a&v=2&vc=47&vn=v6.1.0&limit=20";
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld",string,_offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *cateList = result[@"list"];
        if (_isRefresh) {
            if (self.NewArray.count > 0) {
                [self.NewArray removeAllObjects];
            }
        }
        for (NSDictionary *listDic in cateList) {
            [self.NewArray addObject:listDic];
        }
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}
- (void)getDatesload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    NSString *url = @"http://api.haodou.com/index.php?appid=4&appkey=573bbd2fbd1a6bac082ff4727d952ba3&appsign=ee58d9fa438df9d2d990c11b4b417b11&channel=appstore&deviceid=0f607264fc6318a92b9e13c65db7cd3c%7C2F8CCE8D-7B19-4DFD-BA50-2B848362FE32%7C20562653-A42D-4206-AFAB-7933D37ECF7D&format=json&loguid=&method=Video.getVideoListByCate&nonce=1459401877&sessionid=1459401425&signmethod=md5&timestamp=1459401877&uuid=6c34fd8486aea35729d36d94864af09a&v=2&vc=47&vn=v6.1.0";
    [manager GET:[NSString stringWithFormat:@"%@&cate_id=%@&limit=20&offset=%ld&type=1",url,self.videoId,_offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *video = result[@"list"];
        if (_isRefresh) {
            if (self.classArray.count > 0) {
                [self.classArray removeAllObjects];
            }
        }
        for (NSDictionary *listDic in video) {
            [self.classArray addObject:listDic];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}
#pragma mark ********** 代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
    for (UIView *viewi in cell.contentView.subviews) {
        [viewi removeFromSuperview];
    }
    if ([self.type isEqualToString:@"0"]) {
        NSMutableArray *group = self.VideoArray[indexPath.section];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, cell.frame.size.width-4, cell.frame.size.height-30)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:group[indexPath.row][@"Cover"]] placeholderImage:nil];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 25,cell.frame.size.width - 10,20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text =group[indexPath.row][@"Title"];
        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
    }
    if ([self.type isEqualToString:@"1"]) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, cell.frame.size.width-4, cell.frame.size.height-30)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.NewArray[indexPath.row][@"Cover"]] placeholderImage:nil];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 25,cell.frame.size.width - 10,20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text =self.NewArray[indexPath.row][@"Title"];
        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
    }
    if ([self.type isEqualToString:@"2"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, cell.frame.size.width-4, cell.frame.size.height-30)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.classArray[indexPath.row][@"Cover"]] placeholderImage:nil];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 25,cell.frame.size.width - 10,20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text =self.classArray[indexPath.row][@"Title"];
        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"0"]) {
        NSArray *group = self.VideoArray[section];
        return group.count;
    }
    if ([self.type isEqualToString:@"1"]) {
        return self.NewArray.count;
    }
    if ([self.type isEqualToString:@"2"]) {
        return self.classArray.count;
    }else
        return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.type isEqualToString:@"0"]) {
        return self.VideoArray.count;
    }
    else
        return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"0"]) {
        StoryViewController *storyVC = [[StoryViewController alloc] init];
        NSMutableArray *group = self.VideoArray[indexPath.section];
        storyVC.title = group[indexPath.row][@"Title"];
        storyVC.videoId = group[indexPath.row][@"VideoId"];
        [self.navigationController pushViewController:storyVC animated:YES];    }
    if ([self.type isEqualToString:@"1"]) {
        StoryViewController *storyVC = [[StoryViewController alloc] init];
        storyVC.title = self.NewArray[indexPath.row][@"Title"];
        storyVC.videoId = self.NewArray[indexPath.row][@"VideoId"];
        [self.navigationController pushViewController:storyVC animated:YES];
    }
    if ([self.type isEqualToString:@"2"]) {
        StoryViewController *storyVC = [[StoryViewController alloc] init];
        storyVC.title = self.classArray[indexPath.row][@"Title"];
        storyVC.videoId = self.classArray[indexPath.row][@"VideoId"];
        [self.navigationController pushViewController:storyVC animated:YES];
    }
}

#pragma mark ********** 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0;
        //每一行的间距
        layout.minimumLineSpacing = 2;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 2);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/2 - 4,135);
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) collectionViewLayout:layout];
        
        //注册cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellString];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return  _collectionView;
}

- (NSMutableArray *)CateArray{
    if (_CateArray == nil) {
        self.CateArray = [NSMutableArray new];
    }
    return _CateArray;
}
- (NSMutableArray *)VideoArray{
    if (_VideoArray == nil) {
        self.VideoArray = [NSMutableArray new];
    }
    return _VideoArray;
}
- (NSMutableArray *)NewArray{
    if (_NewArray == nil) {
        self.NewArray = [NSMutableArray new];
    }
    return _NewArray;
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
