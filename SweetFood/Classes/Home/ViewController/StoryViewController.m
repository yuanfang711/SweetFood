//
//  StoryViewController.m
//  普通详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StoryViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "TabbarViewController.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface StoryViewController ()<UITableViewDataSource,UITableViewDelegate,WeiboSDKDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UIView *showMoview;
@property (strong, nonatomic)  UIView *showView;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIView *shareView;
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
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight - 64)];
    self.shareView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:0.2];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0, kScreenWitch-10, kScreenhight-64);
    [button addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:button];
    
    self.shareView.hidden = YES;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StepsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    rightItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)backView{
    self.shareView.hidden = YES;
}
- (void)shareAction{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *name = [userDefault objectForKey:@"name"];
    if (name ==nil) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有登录，是否先去登陆" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
            tabbarVC.selectedIndex = 2;
            self.view.window.rootViewController = tabbarVC;
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }else
    {
        self.shareView.hidden = NO;
        //提示框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将内容分享到新浪微博" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shareWeiBoAction];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
}

-(WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    NSString *string = self.infoDic[@"Cover"];
    NSArray *array = [string componentsSeparatedByString:@"/l/"];
    NSString *movie = array[1];
    NSArray *urlsting = [movie componentsSeparatedByString:@"_"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://v.hoto.cn/%@.mp4",urlsting[0]]];
    NSString *str = [NSString stringWithFormat:@"甜馨美食应用分享：%@%@%@",self.infoDic[@"Title"],url,self.infoDic[@"Intro"]];
    message.text = str;
    return message;
}
- (void)shareWeiBoAction{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [ WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"MeViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    [self removeAction];
}

- (void)removeAction{
    self.shareView.hidden = YES;
}
- (void)changeAction{
    self.shareView.hidden = YES;
}

- (void)showMoviewImageView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kScreenWitch, kScreenhight/2-80);
    UIImageView *movieView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.showMoview.frame.size.width, self.showMoview.frame.size.height)];
    [movieView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"VideoCover"]] placeholderImage:nil];
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
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, kScreenWitch-20, 20)];
        dateLable.font = [UIFont systemFontOfSize:16.0];
        dateLable.text = self.infoDic[@"CreateTime"];

        dateLable.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0];
        [view addSubview:dateLable];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 40, 40)];
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"UserInfo"][@"Avatar"]] placeholderImage:nil];
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
        UILabel *intio = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, kScreenWitch - 20, 80)];
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenhight/2 -80, kScreenWitch, kScreenhight-kScreenhight/2 + 20) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (UIView *)showMoview{
    if (_showMoview == nil) {
        _showMoview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/2 -80)];
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

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
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
