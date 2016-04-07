//
//  RegisterViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "RegisterViewController.h"
#import "TabbarViewController.h"
#import "UIViewController+Common.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *uesrText;

@property (nonatomic, strong) UITextField *passText;

@property (nonatomic, strong) UITextField *agssinpassText;

@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation RegisterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackButtonWithImage:@"back"];
    self.title = @"注册";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.uesrText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/5, kScreenWitch*0.75, 45)];
    self.uesrText.backgroundColor = [UIColor whiteColor];
    self.uesrText.placeholder = @"请输入用户名";
    self.uesrText.borderStyle = UITextBorderStyleRoundedRect;
    self.uesrText.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:self.uesrText];
    
    self.passText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/5 +50, kScreenWitch*0.75, 45)];
       self.passText.borderStyle = UITextBorderStyleRoundedRect;
    self.passText.textAlignment = NSTextAlignmentCenter;
    self.passText.backgroundColor = [UIColor whiteColor];
    self.passText.placeholder = @"请输入密码";
     [self.view addSubview:self.passText];
    
    
    self.agssinpassText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/5 +100, kScreenWitch*0.75, 45)];
    self.agssinpassText.backgroundColor = [UIColor whiteColor];
       self.agssinpassText.borderStyle = UITextBorderStyleRoundedRect;
    self.agssinpassText.textAlignment = NSTextAlignmentCenter;
    self.agssinpassText.placeholder = @"请再次输入密码";
    [self.view addSubview:self.agssinpassText];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registerButton.frame = CGRectMake(kScreenWitch / 8, kScreenhight/5 + 150, kScreenWitch*0.75, 45);
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [UIColor whiteColor];
    [self.registerButton addTarget:self action:@selector(registerActtion) forControlEvents:UIControlEventTouchUpInside];

     [self.view addSubview:self.registerButton];
    self.passText.secureTextEntry = YES;
    self.agssinpassText.secureTextEntry = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

- (void)registerActtion {
    if (![self cieck]) {
        return ;
    }
    [ProgressHUD show:@"正在注册"];
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.uesrText.text];
    [bUser setPassword:self.passText.text];
    [bUser setObjectId:self.agssinpassText.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已注册成功，请返回登录界面，登录" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *success = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
                tabbarVC.selectedIndex = 2;
                self.view.window.rootViewController = tabbarVC;
            }];
            [alertController addAction:success];
            [self presentViewController:alertController animated:YES completion:nil];
            NSLog(@"注册成功");
        }else{
            [ProgressHUD showError:@"注册失败"];
            NSLog(@"%@",error);
        }
    }];
}

//注册是否成功
- (BOOL)cieck{
    //用户名不能为空且不可为空格
    if (self.uesrText.text.length <= 0 && [self.uesrText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不能为空且不能出现空格" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }//
    if (![self.passText.text isEqualToString:self.agssinpassText.text]){
        //提示框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码两次输入不同，请再次输入" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];

        return NO;
    }
    if (self.passText.text.length <= 0 && [self.passText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0){
        //提示密码不为空
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空，请确认输入" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    return YES;
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

#pragma mark ------- 懒加载

//- (UITextField *)uesrText{
//    if (_uesrText == nil) {
//        _uesrText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/2, kScreenWitch*0.75, 45)];
//    }
//    return _uesrText;
//}

//- (UITextField *)passText{
//    if (_passText == nil) {
//        _passText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/2 +50, kScreenWitch*0.75, 45)];
//    }
//    return  _passText;
//}
//
//- (UITextField *)agssinpassText{
//    if (_agssinpassText == nil) {
//        _agssinpassText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWitch / 8, kScreenhight/2 +100, kScreenWitch*0.75, 45)];
//    }
//    return _agssinpassText;
//}


//- (UIButton *)registerButton{
//    if (_registerButton == nil) {
//        _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        self.registerButton.frame = CGRectMake(kScreenWitch / 8, kScreenhight/2 + 150, kScreenWitch*0.75, 45);
//    }
//    return _registerButton;
//}

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
