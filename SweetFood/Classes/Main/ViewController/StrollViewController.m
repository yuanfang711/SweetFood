//
//  StrollViewController.m
//  视频显示collection
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StrollViewController.h"
#import "MenuModel.h"
#import "ActivityViewController.h"
#import "StoryViewController.h"
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
    [self showBackButtonWithImage:@"back"];
    
    
    [self.view addSubview:self.collectionView];
    [self getDateload];
    
}
#pragma mark -------------请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在请求"];
    _pageMovie = 0;
    
    
    [manager GET:  [NSString stringWithFormat:@"%@&type=%@&cate_id=%@",kToolMovie,self.videoType,self.movieId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        
        NSDictionary *dic = responseObject;
        NSDictionary *result = dic[@"result"];
        NSArray *cateList = result[@"list"];
        for (NSDictionary *listDic in cateList) {
//            MenuModel *model = [[MenuModel alloc] initWithNSDicetionary:listDic];
            [self.cellArray addObject:listDic];
        }
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark ------------- 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellsting forIndexPath:indexPath];
    for (UIView *viewi in cell.contentView.subviews) {
        [viewi removeFromSuperview];
    }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, cell.frame.size.height-30)];
//        imageView.backgroundColor = [UIColor cyanColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.cellArray[indexPath.row][@"Cover"]] placeholderImage:nil];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.frame.size.height - 20,cell.frame.size.width - 10,20)];
        lable.text = self.cellArray[indexPath.row][@"Title"];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.backgroundColor = [UIColor orangeColor];
//        UILabel *play = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.frame.size.height - 20,cell.frame.size.width - 10,20)];
//        lable.text = self.cellArray[indexPath.row][@"Title"];

        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"MianVC" bundle:nil];
    StoryViewController *storyVC = [storyB instantiateViewControllerWithIdentifier:@"movie"];
    storyVC.title = self.cellArray[indexPath.row][@"Title"];
    storyVC.videoId = self.cellArray[indexPath.row][@"VideoId"];
    [self.navigationController pushViewController:storyVC animated:YES];
//    StoryViewController *storyVC = [[StoryViewController alloc ]init];
//    storyVC.videoId = self.cellArray[indexPath.row][@"VideoId"];
//    [self.navigationController pushViewController:storyVC animated:YES];

}

#pragma mark ------------- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
    
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.01;
        //每一行的间距
        layout.minimumLineSpacing = 2;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/2-3 ,135);
        
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
        self.collectionView.backgroundColor = [UIColor whiteColor];
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
