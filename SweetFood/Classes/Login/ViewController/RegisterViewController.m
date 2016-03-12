//
//  RegisterViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userSetText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *agssinPass;
@property (weak, nonatomic) IBOutlet UISwitch *passShow;
- (IBAction)registerButton:(id)sender;

@end

@implementation RegisterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.passText.secureTextEntry = YES;
    self.agssinPass.secureTextEntry = YES;
    
    self.passShow.on = NO;
}


- (IBAction)passShowOrNo:(id)sender {
    UISwitch *swith = sender;
    if (swith.on) {
        self.passText.secureTextEntry = NO;
        self.agssinPass.secureTextEntry = NO;
    }else{
        self.passText.secureTextEntry = YES;
        self.agssinPass.secureTextEntry = YES;

    }
}

- (IBAction)registerButton:(id)sender {
    if ([self cieck]) {
        return ;
    }
    [ProgressHUD show:@"正在注册"];
    
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.userSetText.text];
    [bUser setPassword:self.passText.text];
    [bUser setObjectId:self.agssinPass.text];
    
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *success = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self presentedViewController];
            }];
            UIAlertAction *canle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self presentedViewController];
            }];
            [alertControll addAction:canle];
            [alertControll addAction:success];
        [ProgressHUD showSuccess:@"注册成功"];
            NSLog(@"注册成功");
        }else{
            UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册失败" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *canle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self presentedViewController];
            }];
            [alertControll addAction:canle];
            
            NSLog(@"%@",error);
        }
    }];
}
//注册是否成功
- (BOOL)cieck{
    //用户名不能为空且不可为空格
    if (self.userSetText.text.length <= 0 && [self.userSetText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不能为空且不能出现空格" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }//
    if (![self.passText.text isEqualToString:self.agssinPass.text]){
        //提示框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码两次输入不同，请再次输入" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];

        return NO;
    }//用正则表达式来判断是手机挂号
    if (self.passText.text.length <= 0 && [self.passText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0){
        //提示密码不为空
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
