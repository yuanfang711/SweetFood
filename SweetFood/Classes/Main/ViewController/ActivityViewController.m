//
//  ActivityViewController.m
//  详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ProgressHUD.h"
#import "StepsModel.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "StepsTableViewCell.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "LoginViewController.h"
#import "TabbarViewController.h"
@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate,WeiboSDKDelegate>{
    CGFloat height;
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) UIView *shareView;
@end


@implementation ActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //返回按钮
    [self showBackButtonWithImage:@"back"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self getMenuData];
    [self.view addSubview:self.shareView];

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
    NSString *str = [NSString stringWithFormat:@"甜馨美食应用分享：%@%@%@",self.infoDic[@"Title"],self.infoDic[@"Cover"],self.infoDic[@"Intro"]];
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

+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kScreenWitch - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height;
}
//详情
- (void)detailsbutton{
    self.headView.frame = CGRectMake(5, 5, kScreenWitch - 10, 480);
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 240)];
    [ImageView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"Cover"]] placeholderImage:nil];
    [self.headView addSubview:ImageView];
    
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(10, 245, kScreenWitch, 35)];
    titleName.text = self.infoDic[@"Title"];
    [self.headView addSubview:titleName];
    
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 283, kScreenWitch-20, 20)];
    dateLable.font = [UIFont systemFontOfSize:16.0];
    dateLable.text = self.infoDic[@"CreateTime"];
    [self.headView addSubview:dateLable];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 305, 40, 40)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"UserInfo"][@"Avatar"]] placeholderImage:nil];
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    
    [self.headView addSubview:iconView];
    
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 305, kScreenWitch - 90, 40)];
    Name.text = self.infoDic[@"UserInfo"][@"UserName"];
    [self.headView  addSubview:Name];
    
    UILabel *introlLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, kScreenWitch-20, 100)];
    introlLable.numberOfLines = 0;
    introlLable.text = self.infoDic[@"Intro"];
    CGFloat heights = [[self class] getTextHeightWithText:introlLable.text];
    introlLable.font = [UIFont systemFontOfSize:13.0];
    CGRect frame = introlLable.frame;
    frame.size.height = heights;
    introlLable.frame = frame;
    [self.headView addSubview:introlLable];
    
    
    UILabel *tame = [[UILabel alloc] initWithFrame:CGRectMake(10, 350 + heights, kScreenWitch/2-40, 30)];
    tame.text = @"制作时间";
    [self.headView addSubview:tame];
    
    UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2-50, 350 + heights, kScreenWitch-60, 30)];
    workTimeL.text = [NSString stringWithFormat:@"%@",self.infoDic[@"CookTime"]];
    [self.headView addSubview:workTimeL];
    CGRect headFrame = self.headView.frame;
    headFrame.size.height = heights + 380;
    self.headView.frame = headFrame;
    
    self.tableView.tableHeaderView = self.headView;
    //    }
}
//请求数据
- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    [manager GET:[NSString stringWithFormat:@"%@&rid=%@",kMenuDetaills,self.fooDid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        
        //详情
        self.infoDic = result[@"info"];
        //食材
        if (self.cellArray.count > 0) {
            [self.cellArray removeAllObjects];
        }
        for (NSDictionary *dic in self.infoDic[@"Stuff"]) {
            [self.cellArray addObject:dic];
        }
        //步骤
        if (self.stepArray.count > 0) {
            [self.stepArray removeAllObjects];
        }
        for (NSDictionary *dic  in self.infoDic[@"Steps"]) {
            StepsModel *model = [StepsModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.stepArray addObject:model];
        }
        [self.tableView reloadData];
        [self detailsbutton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cella = @"stuff";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cella];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cella];
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWitch/2-5, 20)];
            name.textColor = [UIColor grayColor];
            name.text = self.cellArray[indexPath.row][@"name"];
            UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2+15, 5, kScreenWitch/2-5, 20)];
            self.tableView.separatorColor = [UIColor blackColor];
            weight.text =  self.cellArray[indexPath.row][@"weight"];
            weight.textColor = [UIColor grayColor];
            [cell addSubview:name];
            [cell addSubview:weight];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        StepsTableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        viewCell.model = self.stepArray[indexPath.row];
        viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return viewCell;
    }
    else{
        static NSString *cellView = @"stepssss";
        UITableViewCell *viewcells = [tableView dequeueReusableCellWithIdentifier:cellView];
        return viewcells;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.cellArray.count;
    }
    if (section == 1) {
        return self.stepArray.count;
    }else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }
    if (indexPath.section == 1) {
        return 95;
        
    }else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"食材";
    }if (section == 1) {
        return @"步骤";
    }
    return @"";
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}
#pragma mark ---------- 懒加载
- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
}

- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, kScreenWitch- 10, kScreenhight-64) style:UITableViewStylePlain];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
}
- (NSMutableArray *)stepArray{
    if (_stepArray == nil) {
        _stepArray = [NSMutableArray new];
    }
    return _stepArray;
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
