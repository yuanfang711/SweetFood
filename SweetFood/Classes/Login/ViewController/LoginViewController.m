//
//  LoginViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/BmobUser.h>
#import "MineViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self showBackButtonWithImage:@"back"];
    
    self.passText.secureTextEntry = YES;
    
}
- (IBAction)loginButtonAction:(id)sender {
    [ProgressHUD show:@"正在登陆"];
    [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.passText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD showSuccess:@"登录成功"];
            UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"MineVC" bundle:nil];
            UINavigationController *mineVC = storyB.instantiateInitialViewController;
            [self.navigationController presentViewController:mineVC animated:YES completion:nil];
        }
        else{
            [ProgressHUD dismiss];
            //提示框
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请再次登录" preferredStyle:UIAlertControllerStyleActionSheet];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
        }

    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
- (IBAction)registerButtonAction:(id)sender {
    
    RegisterViewController *registreVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registreVC animated:YES];
    
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
