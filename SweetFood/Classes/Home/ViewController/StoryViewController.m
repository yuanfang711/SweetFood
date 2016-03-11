//
//  StoryViewController.m
//  普通详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIButton *DetailsButtonView;

@property (weak, nonatomic) IBOutlet UIButton *foodBuutonView;
@property (weak, nonatomic) IBOutlet UIButton *stepButtonView;

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *stuff;
@property (nonatomic, strong)  NSMutableArray *steps;
@property (nonatomic, strong) UIView *showView;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    //详情
    [self DetailsShow];
    
    [self.DetailsButtonView addTarget:self action:@selector(DetailViewShowView) forControlEvents:UIControlEventTouchUpInside];
    [self.foodBuutonView addTarget:self action:@selector(foodViewShowView) forControlEvents:UIControlEventTouchUpInside];
    [self.stepButtonView addTarget:self action:@selector(stepsViewShowView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ------ 三种界面
- (void)DetailsShow{
    UIView *view = [[UIView alloc] initWithFrame:self.showView.frame];
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWitch, 35)];
    titleName.text = self.infoDic[@"Title"];
    //    titleName.backgroundColor = kViewColor;
    [view addSubview:titleName];
    
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, kScreenWitch/2-20, 20)];
    dateLable.font = [UIFont systemFontOfSize:16.0];
    //    dateLable.backgroundColor = kViewColor;
    dateLable.text = self.infoDic[@"CreateTime"];
    [view addSubview:dateLable];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 40, 40)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"UserInfo"][@"Avatar"]] placeholderImage:nil];
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    
    //    iconView.backgroundColor = kViewColor;
    [view addSubview:iconView];
    
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, kScreenWitch - 60, 40)];
    //    Name.backgroundColor = kViewColor;
    Name.text = self.infoDic[@"UserInfo"][@"UserName"];
    [view  addSubview:Name];
    
    UILabel *introlLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, kScreenWitch, 100)];
    introlLable.numberOfLines = 0;
    introlLable.text = self.infoDic[@"Intro"];
    //    introlLable.backgroundColor = kViewColor;
    introlLable.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:introlLable];
    
    UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, kScreenWitch, 30)];
    //    workTimeL.backgroundColor = kViewColor;
    workTimeL.text = [NSString stringWithFormat:@"制作时间：%@",self.infoDic[@"CookTime"]];
    [view addSubview:workTimeL];
    [self.showView addSubview:view];
}

- (void)FoodHow{
    
}

- (void)stepMarkFood{
    
}
#pragma mark ------ 界面点击方法
//详情点击方法
- (void)DetailViewShowView{
    [self.showView removeFromSuperview];
    [self DetailsShow];
}

- (void)foodViewShowView{
    [self.showView removeFromSuperview];
    [self FoodHow];
}

- (void)stepsViewShowView{
    [self.showView removeFromSuperview];
    [self stepMarkFood];
}
//请求数据
- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    
    [manager GET:[NSString stringWithFormat:@"%@&rid=%@",kMenuDetaills,self.videoId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //详情
        self.infoDic = result[@"info"];
        //食材
        NSArray *stuffarray = self.infoDic[@"Stuff"];
//        NSMutableArray *stuff = [NSMutableArray new];
        for (NSDictionary *dic in stuffarray) {
            [self.stuff addObject:dic];
        }
        //步骤
        NSArray *step = self.infoDic[@"Steps"];
//        NSMutableArray *step = [NSMutableArray new];
        for (NSDictionary *dic  in step) {
            [self.steps addObject:dic];
        }
        [self reloadInputViews];
        if (self.cellArray.count > 0) {
            [ProgressHUD showSuccess:@"加载成功"];
        }
        else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cella = @"stuff";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cella];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cella];
            cell.backgroundColor = [UIColor cyanColor];
        }
        return cell;
    }else{
        static NSString *cellView = @"step";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellView];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellView];
            cell.backgroundColor = [UIColor magentaColor];
        }
        
        return cell;}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark ---------- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 480, kScreenWitch-10, kScreenhight -480) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 50;
    }
    return _tableView;
}
- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
}
- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
}

-(UIView *)showView{
    if (_showView == nil) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 283)];
    }
    return _showView;
}

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
