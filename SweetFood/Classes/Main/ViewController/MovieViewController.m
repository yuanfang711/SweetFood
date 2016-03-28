//
//  MovieViewController.m
//  视屏
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieModel.h"
#import "HeadCollectionView.h"
#import "ActivityViewController.h"
#import "LoveModel.h"
#import "StrollViewController.h"
#import "VOSegmentedControl.h"
#import "StoryViewController.h"

static NSString *cellString = @"iOS";
static NSString *headCellString = @"food";
@interface MovieViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) VOSegmentedControl *vosC;
@property (strong, nonatomic) UIView *toolView;
@property (nonatomic, strong) NSMutableArray *CateArray;
@property (nonatomic, strong) NSMutableArray *VideoArray;
@property (nonatomic, strong) NSMutableArray *name;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"菜谱视频";
    [self showBackButtonWithImage:@"back"];
    self.view.backgroundColor = kViewColor;
    [self getDateload];
    //    self.toolView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.toolView];
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
            [self.name addObject:listDic];
            NSArray *array = listDic[@"List"];
            [self.VideoArray addObject:array];
            
        }
        [self.collectionView reloadData];
        [self SettingToolButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}



- (void)SettingToolButton{
    for (int i = 0; i < self.CateArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWitch/self.CateArray.count * i , 2, kScreenWitch/self.CateArray.count, 34);
        [button setTitle:self.CateArray[i][@"CateName"] forState:UIControlStateNormal];
        button.tag = 100 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.layer.borderWidth = 0.5f;
        button.showsTouchWhenHighlighted= YES;
        CGColorSpaceRef colorref = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorref, (CGFloat[]){0.9,0.8,0.5,1});
        button.layer.borderColor =color;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:button];
    }
}

- (void)ButtonAction:(UIButton *)button{
    StrollViewController *strollVC = [[StrollViewController alloc] init];
    strollVC.movieId = self.CateArray[button.tag- 100][@"CateId"];
    strollVC.videoType = @"1";
    strollVC.title = self.CateArray[button.tag- 100][@"CateName"];
    [self.navigationController pushViewController:strollVC animated:YES];
}


#pragma mark ********** 代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
    for (UIView *viewi in cell.contentView.subviews) {
        [viewi removeFromSuperview];
    }
    NSMutableArray *group = self.VideoArray[indexPath.section];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, cell.frame.size.height-30)];
        //        imageView.backgroundColor = [UIColor cyanColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:group[indexPath.row][@"Cover"]] placeholderImage:nil];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.frame.size.height - 20,cell.frame.size.width - 10,20)];
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable.text =group[indexPath.row][@"Title"];
    
    

        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:imageView];
        
        
        cell.backgroundColor = [UIColor whiteColor];
  
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *group = self.VideoArray[section];
    return group.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.VideoArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
      StoryViewController *storyVC = [[StoryViewController alloc] init];
    NSMutableArray *group = self.VideoArray[indexPath.section];
    storyVC.title = group[indexPath.row][@"Title"];
    storyVC.videoId = group[indexPath.row][@"VideoId"];
    [self.navigationController pushViewController:storyVC animated:YES];
//    
//     ActivityViewController *actiVC = [[ActivityViewController alloc ]init];
//
//    actiVC.fooDid = self.VideoArray[indexPath.row][@"VideoId"];
//    [self.navigationController pushViewController:actiVC animated:YES];
    
}




#pragma mark ********** 懒加载

-(UIView *)toolView {
    if (_toolView == nil) {
        self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWitch, 38)];
        self.toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.1;
        //每一行的间距
        layout.minimumLineSpacing = 5;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //        layout.headerReferenceSize = CGSizeMake(kScreenWitch, 40);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kScreenWitch/2- 10,135);
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 102, kScreenWitch, kScreenhight -102) collectionViewLayout:layout];
        
        //注册cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellString];
        
        //        //注册区头
        //        [self.collectionView registerNib:[UINib nibWithNibName:@"HeadCollectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCellString];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
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

//- (HeadCollectionView *)headView{
//    if (_headView == nil) {
//        _headView = [[HeadCollectionView alloc] init];
//    }
//    return _headView;
//}

- (NSMutableArray *)name{
    if (_name == nil) {
        _name = [NSMutableArray new];
    }
    return _name;
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
