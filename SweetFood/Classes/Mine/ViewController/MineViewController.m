//
//  MineViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MineViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
@interface MineViewController ()
//@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *cellArray ;

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *shareView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";

    
    
    
    UIImageView *imageviews = [[UIImageView alloc] initWithFrame:CGRectMake(5, 64, kScreenWitch, kScreenhight- 64)];
    imageviews.image = [UIImage imageNamed:@"111.gif"];
    
    [self.view addSubview:imageviews];
    
    
    UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonLogin.frame = CGRectMake(kScreenWitch /4, kScreenhight/3, kScreenWitch / 2 , 40);
    [buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    buttonLogin.backgroundColor = [UIColor whiteColor];
    [buttonLogin setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:buttonLogin];
    
    
    UIButton *buttonRegister = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonRegister.frame = CGRectMake(kScreenWitch / 4, kScreenhight/3 + 50, kScreenWitch / 2, 40);
    [buttonRegister setTitle:@"注册" forState:UIControlStateNormal];
     [buttonRegister setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    buttonRegister.backgroundColor = [UIColor whiteColor];
    [buttonRegister addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonRegister];
    
    
    
    
//    [self.view addSubview:self.headView];
    
    
    
    
    
    self.cellArray =[NSMutableArray arrayWithObjects:@"清除缓存",@"好友分享", nil];
    
}

////当xiew出现时调用此方法
//-(void)viewWillAppear:(BOOL)animated{
//    //大小
//    SDImageCache *chche = [SDImageCache sharedImageCache];
//    
//    NSUInteger chachesize = [chche getSize];
//    
//    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.2fM)",(float)chachesize/1024/1204];
//    //使用替换，不能用插入，替换得出新写的数据。插入使原有的数组的个数多一个
//    [self.cellArray replaceObjectAtIndex:0 withObject:cacheStr];
//    //cell的位置；
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//    //刷新单行的cell
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    [super viewWillAppear:animated];
//    
//}

- (void)RegisterAction{
    RegisterViewController *registreVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registreVC animated:YES];
}

- (void)LoginAction{
    UIStoryboard *stoer = [UIStoryboard storyboardWithName:@"MineVC" bundle:nil];
    LoginViewController *loginVC = [stoer instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:loginVC animated:YES];
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellstring = @"ios";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
//    if (cell== nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
//    }
//    cell.textLabel.text = self.cellArray[indexPath.row];
//    return cell;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.cellArray.count;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 44;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:{//找到存储的位置NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
//            //清除里面添加的图片
//            SDImageCache *image = [SDImageCache sharedImageCache];
//            //调用方法，清除所有一起拿存储的图片
//            [image clearDisk];
//            [self.cellArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"清除缓存(%.0fM)",(float)[image getSize]]];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            //刷新单行的cell
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }break;
//        case 1:{
//            [self share];
//        }
    
//    }
//}

-(void)share{
    UIWindow *sharewindow = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc] initWithFrame:self.view.frame];
    self.blackView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [sharewindow addSubview:self.blackView];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWitch, kScreenWitch, 250)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.blackView addSubview:self.shareView];
    //微博
    UIButton *weibobutton = [UIButton buttonWithType:UIButtonTypeCustom];
    weibobutton.frame = CGRectMake(20, 20, 70, 70);
    [weibobutton setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_login_button_with_frame_logo_focused"] forState:UIControlStateNormal];
    [weibobutton addTarget:self action:@selector(getWeiBoShare) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weiboL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 70, 10)];
    weiboL.text = @"微博分享";
    weiboL.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboL];
    [self.shareView addSubview:weibobutton];
//    
//    //微信朋友
//    UIButton *friendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    friendbutton.frame = CGRectMake(130, 20, 70, 70);
//    [friendbutton setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
//    [friendbutton addTarget:self action:@selector(getFriendShare) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *weixinL = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 70, 10)];
//    weixinL.text = @"微信好友";
//    weixinL.textAlignment = NSTextAlignmentCenter;
//    [self.shareView addSubview:weixinL];
//    [self.shareView addSubview:friendbutton];
//    //朋友圈
//    UIButton *circlebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    circlebutton.frame = CGRectMake(250, 20, 70, 70);
//    [circlebutton setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
//    [circlebutton addTarget:self action:@selector(getCircleShare) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *circleL = [[UILabel alloc] initWithFrame:CGRectMake(240, 90, 90, 10)];
//    circleL.text = @"朋友圈分享";
//    [self.shareView addSubview:circleL];
//    [self.shareView addSubview:circlebutton];
//    
    //清除
    UIButton *removebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    removebutton.frame = CGRectMake(30, 120, kScreenWitch - 60, 30);
    removebutton.backgroundColor = [UIColor brownColor];
    [removebutton setTitle:@"取消" forState:UIControlStateNormal];
    [removebutton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removebutton];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.6;
        self.shareView.frame =CGRectMake(0, kScreenhight - 240, kScreenWitch, 240);
        self.tabBarController.tabBar.hidden = YES;
    }];
    
}
- (WBMessageObject *)messageToshare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"此内容由甜馨美食测试使用分享";
    return message;
}

//微博分享
- (void)getWeiBoShare{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = KRedirectURI;
    authRequest.scope = @"all";
    //    authRequest.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController"};
    
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToshare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    [self getBack];
}
- (void)getBack{
    [UIView animateWithDuration:1.0 animations:^{
        [self.shareView removeFromSuperview];
        [self.blackView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
    }];
}
//-(UIView *)headView{
//    if (_headView == nil) {
//        _headView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWitch - 10, kScreenhight - 70)];
////        self.headView.backgroundColor = [UIColor cyanColor];
//        
//        [self.headView addSubview:imageviews];
//        
//        
//    }
//    return _headView;
//}

- (NSMutableArray *)cellArray{
    if (_cellArray == 0) {
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
