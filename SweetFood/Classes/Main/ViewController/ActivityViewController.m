//
//  ActivityViewController.m
//  活动列表
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"


@interface ActivityViewController ()

@property (nonatomic, strong) UITableView *menutablew;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view.
    
    
    [self showBackButtonWithImage:@"back"];
    
    [self.view addSubview:self.menutablew];
    
//    [self getMenuData];
}

#pragma mark ---------- 代理
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//  
//}
#pragma mark ---------- 懒加载


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
