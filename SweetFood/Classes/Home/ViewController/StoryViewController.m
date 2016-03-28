//
//  StoryViewController.m
//  普通详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StoryViewController.h"
#import "HWTools.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface StoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UIView *showMoview;
@property (strong, nonatomic)  UIView *showView;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithImage:@"back"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWitch, 220)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.showMoview];
    [self getMenuData];
}
- (void)showMoviewImageView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kScreenWitch, kScreenhight/2-80);
    UIImageView *movieView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.showMoview.frame.size.width, self.showMoview.frame.size.height)];
    [movieView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"Cover"]] placeholderImage:nil];
    [button addTarget:self action:@selector(MoviePlayAction) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:movieView];
    [self.showMoview addSubview:button];
}
- (void)MoviePlayAction{
    NSString *string = self.infoDic[@"Cover"];
    NSArray *array = [string componentsSeparatedByString:@"/l/"];
    NSString *movie = array[1];
    NSArray *urlsting = [movie componentsSeparatedByString:@"_"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://v.hoto.cn/%@.mp4",urlsting[0]]];
    //初始化播放器并设置播放模式
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //.view 播放器视图，如果要显示视频，必须将此播放器添加到控制器视图中
    _moviePlayer.view.frame = self.showMoview.frame;
    _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer play];
}

- (void)DetailsShow{
    if (self.infoDic.count > 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.showView.frame.size.width, self.showView.frame.size.height)];
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWitch, 35)];
        titleName.text = self.infoDic[@"Title"];
        titleName.font = [UIFont systemFontOfSize:20.0];
        [view addSubview:titleName];
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, kScreenWitch/2-20, 20)];
        dateLable.font = [UIFont systemFontOfSize:16.0];
        dateLable.tintColor = [UIColor grayColor];
        dateLable.text = self.infoDic[@"CreateTime"];
        [view addSubview:dateLable];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 40, 40)];
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"Cover"]] placeholderImage:nil];
        iconView.layer.cornerRadius = 20;
        iconView.clipsToBounds = YES;
        
        iconView.backgroundColor = kViewColor;
        [view addSubview:iconView];
        
        UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, kScreenWitch - 60, 40)];
        Name.text = self.infoDic[@"UserInfo"][@"UserName"];
        [view  addSubview:Name];
        
        
        UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, kScreenWitch-30,30)];
        workTimeL.text = [NSString stringWithFormat:@"制作时间:%@",self.infoDic[@"CookTime"]];
        [view addSubview:workTimeL];
        
        CGFloat height = [[self class] getTextHeightWithText:self.infoDic[@"Intro"]];
        UILabel *intio = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, kScreenWitch - 20, 80)];
        intio.font = [UIFont systemFontOfSize:15.0];
        intio.text = self.infoDic[@"Intro"];
        intio.font = [UIFont systemFontOfSize:13.0];
        intio.numberOfLines = 0;
        [view addSubview:intio];
        [self.showView addSubview:view ];
        CGRect frame = self.showView.frame;
        frame.size.height = height + 160;
        self.showView.frame = frame;
        self.tableView.tableHeaderView = self.showView;
    }
}
#pragma mark ------- 数据请求

//请求数据
- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    
    [manager GET:[NSString stringWithFormat:@"%@&rid=%@",kMovieAction,self.videoId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        NSDictionary *info = result[@"info"];
        //详情
        self.infoDic = info;
        
        //食材
        NSArray *stuffarray = info[@"Stuff"];
        for (NSDictionary *dic in stuffarray) {
            [self.cellArray addObject:dic];
        }
        
        [self.tableView reloadData];
        //详情
        [self DetailsShow];
        [self showMoviewImageView];
        [ProgressHUD showSuccess:@"加载成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -----------  代理
+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kScreenWitch - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cella = @"cellll";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cella];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cella];
        [cell.contentView removeFromSuperview];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWitch/2-5, 20)];
        name.textColor = [UIColor grayColor];
        name.text = self.cellArray[indexPath.row][@"name"];
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2+15, 5, kScreenWitch/2-5, 20)];
        self.tableView.separatorColor = [UIColor blackColor];
        weight.text =  self.cellArray[indexPath.row][@"weight"];
        weight.textColor = [UIColor grayColor];
        self.tableView.rowHeight = 30;
        [cell addSubview:name];
        [cell addSubview:weight];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"食材";
}
#pragma mark ************ 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenhight/2 -80, kScreenWitch, kScreenhight/2+80) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (UIView *)showMoview{
    if (_showMoview == nil) {
        _showMoview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWitch, kScreenhight/2 -80)];
        self.showMoview.backgroundColor = [UIColor cyanColor];
    }
    return _showMoview;;
}
- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        self.infoDic = [NSDictionary new];
    }
    return _infoDic;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        self.cellArray = [NSMutableArray new];
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
