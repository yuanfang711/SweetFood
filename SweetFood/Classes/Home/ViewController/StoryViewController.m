//
//  StoryViewController.m
//  普通详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StoryViewController.h"
#import "StuffView.h"
#import "StepsView.h"
#import "HWTools.h"
@interface StoryViewController ()
@property (strong, nonatomic)  UIView *showMoview;

@property (strong, nonatomic)  UIScrollView *showView;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong)  NSMutableArray *stuff;
@property (nonatomic, strong)  NSMutableArray *steps;

@property (nonatomic, strong) StuffView *stuffView;
@property (nonatomic, strong) StepsView *stepView;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithImage:@"back"];
    self.view.backgroundColor = [UIColor whiteColor];

    self.showView.scrollEnabled = YES;
    [self.view addSubview:self.showView ];
    [self.view addSubview:self.showMoview];
}

- (void)showMoviewImageView{
    if (self.steps.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, self.showMoview.frame.size.width, self.showMoview.frame.size.height);
        [button addTarget:self action:@selector(MoviewPlay) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *iamgesView = [[UIImageView alloc] initWithFrame:button.frame];
        [iamgesView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"Cover"]] placeholderImage:nil];
        [button addSubview:iamgesView];
        [self.showMoview addSubview:button];
    }
}
- (void)MoviewPlay{
    
}




#pragma mark ------ show
- (void)DetailsShow{
     UIScrollView *showView =[[UIScrollView alloc] initWithFrame:CGRectMake(5, kScreenhight/3 , kScreenWitch -10, kScreenhight/3*2-40)];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.showView.frame.size.width, self.showView.frame.size.height)];
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWitch, 35)];
    titleName.text = self.infoDic[@"Title"];
    titleName.font = [UIFont systemFontOfSize:20.0];
    //        titleName.backgroundColor = kViewColor;
    [view addSubview:titleName];
    
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, kScreenWitch/2-20, 20)];
    dateLable.font = [UIFont systemFontOfSize:16.0];
    dateLable.tintColor = [UIColor grayColor];
    dateLable.text = self.infoDic[@"CreateTime"];
    [view addSubview:dateLable];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 40, 40)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"UserInfo"][@"Avatar"]] placeholderImage:nil];
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    
    iconView.backgroundColor = kViewColor;
    [view addSubview:iconView];
    
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, kScreenWitch - 60, 40)];
    //        Name.backgroundColor = kViewColor;
    Name.text = self.infoDic[@"UserInfo"][@"UserName"];
    [view  addSubview:Name];
    
//    CGFloat height = []];
    
    UILabel *tame = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, kScreenWitch/2-40, 30)];
    tame.text = @"制作时间";
    [view addSubview:tame];
    
    UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2-50, 110, kScreenWitch-60, 30)];
    //    workTimeL.backgroundColor = kViewColor;
    workTimeL.text = [NSString stringWithFormat:@"%@",self.infoDic[@"CookTime"]];
    [view addSubview:workTimeL];
    
    UILabel *introlLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, kScreenWitch - 20, 200)];
    introlLable.numberOfLines = 0;
    
    introlLable.text = self.infoDic[@"Intro"];
    //    introlLable.backgroundColor = kViewColor;
    
    introlLable.font = [UIFont systemFontOfSize:17.0];
    [view addSubview:introlLable];
    [showView addSubview:view ];
}


//请求数据
- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    
    [manager GET:[NSString stringWithFormat:@"%@&rid=%@",kMovieAction,self.videoId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //详情
        self.infoDic = result[@"info"];
        //食材
        self.stuff = self.infoDic[@"Stuff"];
        NSMutableArray *stuff = [NSMutableArray new];
        for (NSDictionary *dic  in stuff) {
            [self.stuffView.stuffArray addObject:dic];
        }
        //步骤
        self.steps = self.infoDic[@"Steps"];
        NSMutableArray *step = [NSMutableArray new];
        for (NSDictionary *dic  in step) {
            [self.stepView.stepArray addObject:dic];
        }
//        [self.tableView reloadData];
        //详情
        [self getMenuData];
        [self DetailsShow];
        [self showMoviewImageView];
        [ProgressHUD showSuccess:@"加载成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (UIView *)showMoview{
    if (_showMoview == nil) {
        _showMoview = [[UIView alloc] initWithFrame:CGRectMake(5, 70, kScreenWitch -10, kScreenhight/3)];
    }
    return _showMoview;
}



- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
}
- (UIScrollView *)showView{
    if (_showView == nil) {
        _showView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, kScreenhight/3 , kScreenWitch -10, kScreenhight/3*2-40)];
//        self.showView.backgroundColor = [UIColor redColor];
    }
    return _showView;
}

//-(UIView *)showView{
//    if (_showView == nil) {
//        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenhight -345, kScreenWitch, 345)];
////        self.showView.backgroundColor = [UIColor redColor];
//    }
//    return _showView;
//}

- (NSMutableArray *)stuff{
    if (_stuff == nil) {
        _stuff = [NSMutableArray new];
    }
    return _stuff;
}

- (NSMutableArray *)steps{
    if (_steps == nil) {
        _steps = [NSMutableArray new];
    }
    return _steps;
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
