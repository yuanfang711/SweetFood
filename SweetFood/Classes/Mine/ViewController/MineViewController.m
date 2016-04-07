//
//  MineViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MineViewController.h"
#import "RegisterViewController.h"
#import "TabbarViewController.h"
#import "LoginViewController.h"
#import "UIViewController+Common.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface MineViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *grayView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@end

@implementation MineViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
//当xiew出现时调用此方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.passText.secureTextEntry = YES;
    [self.view addSubview:self.loginView];
}

- (IBAction)RegisterAction:(id)sender {
    
    RegisterViewController *registreVC = [[RegisterViewController alloc] init];
    registreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registreVC animated:YES];
}
- (IBAction)LoginAction:(id)sender {
    [ProgressHUD show:@"正在登陆"];
    [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.passText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD showSuccess:@"登录成功"];
            NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
            [userDefault setValue:self.userName.text forKey:@"name"];
            [userDefault synchronize];
            //提示框
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否回到主页继续浏览" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
                self.view.window.rootViewController = tabbarVC;
                tabbarVC.tabBar.tintColor = [UIColor orangeColor];
            }]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
                tabbarVC.selectedIndex = 2;
                tabbarVC.mineNAV = [[UINavigationController alloc] initWithRootViewController:loginVC];
                self.view.window.rootViewController = tabbarVC;
                tabbarVC.tabBar.tintColor = [UIColor orangeColor];
                
            }]];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else{
            [ProgressHUD dismiss];
            //提示框
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请再次登录" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

//点击换行见回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


//点击空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //或者点击除三个输入框外的地方
    //    [self.userName resignFirstResponder];
    //    [self.passText resignFirstResponder];
    //    [self.assginPassText resignFirstResponder];
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
