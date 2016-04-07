//
//  TabbarViewController.m
//  SweetFood
//
//  Created by scjy on 16/4/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "TabbarViewController.h"
#import "LoginViewController.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //主页
    UIStoryboard *mianB = [UIStoryboard storyboardWithName:@"MianVC" bundle:nil];
    self.mainNAV = mianB.instantiateInitialViewController;
    _mainNAV.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    
    _mainNAV.tabBarItem.title = @"菜谱";
    
    //到家
    UIStoryboard *homeB = [UIStoryboard storyboardWithName:@"HomaVC" bundle:nil];
    self.movieNAV = homeB.instantiateInitialViewController;
    self.movieNAV.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    
    self.movieNAV.tabBarItem.title = @"视频";
    
    //我的
    self.mineNAV  = [UINavigationController new];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *name = [userDefault objectForKey:@"name"];
    if (name !=nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        self.mineNAV =[[UINavigationController alloc] initWithRootViewController:login];
    }else{
        
        UIStoryboard *mineB = [UIStoryboard storyboardWithName:@"MineVC" bundle:nil];
        self.mineNAV = mineB.instantiateInitialViewController;
    }
    self.mineNAV.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    self.mineNAV.tabBarItem.title = @"我的";
    //将所见的主界面添加到tabbar的视图上
    self.viewControllers = @[self.mainNAV,self.movieNAV,self.mineNAV];
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
