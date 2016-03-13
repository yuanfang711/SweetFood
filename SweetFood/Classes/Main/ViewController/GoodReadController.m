//
//  GoodReadController.m
//  菜谱列表
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodReadController.h"
#import "GoodTableViewCell.h"
#import "GoodModel.h"
#import "ActivityViewController.h"
#import "StoryViewController.h"
#import "HWTools.h"


@interface GoodReadController ()<UITableViewDelegate,UITableViewDataSource>
{

        CGFloat introlHight;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation GoodReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    
//    self.tableView.sectionIndexColor = [UIColor grayColor];
    
    [self.view addSubview:self.tableView];
    
    [self getDataLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark ---------- 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [NSString stringWithFormat:@"%@%@",kGoodTool,self.goodId]
    [manager GET:[NSString stringWithFormat:@"%@%@",kGoodTool,self.goodId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //头数据
        self.infoDic = result[@"info"];
        //列表
        NSArray *alArray = result[@"list"];
        for (NSDictionary *listDic in alArray) {
            GoodModel *model = [[GoodModel alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:model];
        }
        [self.tableView reloadData];
        [self settingHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)settingHeadView{
    

    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 180)];
//    imageV.backgroundColor = [UIColor redColor];
    //图片
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"AlbumCover"]] placeholderImage:nil];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, kScreenWitch-60, 30)];
    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
    title.text = self.infoDic[@"AlbumTitle"];
    
    //名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/3, 90, kScreenWitch/3, 30)];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = self.infoDic[@"AlbumUserName"];
    
//    //介绍
//    UILabel *introl = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, kScreenWitch-40, 100)];
//    introl.numberOfLines = 0;
//    introl.text = self.infoDic[@"AlbumContent"];
//    introlHight = [[self class] getTextHeightWithText:introl.text];
//    CGRect frame = introl.frame;
//    frame.size.height = introlHight;
//    introl.frame = frame;
    
    [self.headView addSubview:imageV];
    [self.headView addSubview:title];
    [self.headView addSubview:name];
//    [self.headView addSubview:introl];
}


#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    GoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell== nil) {
        cell = [[GoodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    cell.goodModel = self.listArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodModel *model = self.listArray[indexPath.row];
    
    CGFloat cellHeight = [GoodTableViewCell getCellHeightWithGoodModel:model];
    
    return cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *model = self.listArray[indexPath.row];
    if([model.type intValue] == 0){
        ActivityViewController *activityVC = [[ActivityViewController alloc] init];
        activityVC.fooDid = model.foodID;
        activityVC.title = model.title;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
    if ([model.type intValue] == 1) {
//        UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"MianVC" bundle:nil];
//        StoryViewController *storyVC = [storyB instantiateViewControllerWithIdentifier:@"movie"];
          StoryViewController *storyVC = [[StoryViewController alloc] init];
        storyVC.title = model.title;
        storyVC.videoId = model.foodID;
        [self.navigationController pushViewController:storyVC animated:YES];
    }
}

#pragma mark ---------- 懒加载
- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableHeaderView = self.headView;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}


+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kScreenWitch - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    return rect.size.height;
}
- (UIView *)headView{
    if(_headView == nil)
    {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, kScreenWitch -10, 200)];
        CGFloat heightView = [[self class] getTextHeightWithText:self.infoDic[@"AlbumContent"]];
        CGRect frame = self.headView.frame;
        frame.size.height = heightView + 185;
        self.headView.frame = frame;
        
        
    }
    return _headView;
}


- (NSMutableArray *)listArray{
    if ( _listArray == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSDictionary *)infoDic{
    if ( _infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
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
