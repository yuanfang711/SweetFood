//
//  StrollViewController.m
//  视频显示collection
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StrollViewController.h"


static NSString *cellsting = @"movie";
@interface StrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger _pageMovie;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation StrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    [self getDateload];
    
}
#pragma mark -------------请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    _pageMovie = 0;
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld&cate_id=%@",kToolMovie,_pageMovie,self.movieId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        
        NSDictionary *dic = responseObject;
//        NSDictionary *result = dic[@"result"];
//        NSArray *cateList = result[@"CateList"];
//        for (NSDictionary *listDic in cateList) {
//            [self.CateArray addObject:listDic];
//        }
//        NSArray *video = result[@"VideoList"];
//        for (NSDictionary *listDic in video) {
//            [self.name addObject:listDic];
//            NSArray *array = listDic[@"List"];
//            [self.VideoArray addObject:array];
//            
//        }
//        [self.collectionView reloadData];
//        [self SettingToolButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark ------------- 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellsting forIndexPath:indexPath];
//    if (indexPath.row < group.count) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, cell.frame.size.height-30)];
                imageView.backgroundColor = [UIColor cyanColor];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:group[indexPath.row][@"Cover"]] placeholderImage:nil];
    
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.frame.size.height - 20,cell.frame.size.width - 10,20)];
        lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor whiteColor];
//    }

    
    
    return cell;
}
#pragma mark -------------
#pragma mark -------------
#pragma mark ------------- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.1;
        //每一行的间距
        layout.minimumLineSpacing = 2;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/2- 10,135);
        
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) collectionViewLayout:layout];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //将原背景颜色消除
        _collectionView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.5];
        //注册item类型，与下item的设置要一致
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellsting];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray *)cellArray{
    if ( _cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
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
