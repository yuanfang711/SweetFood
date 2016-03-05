//
//  ChufangViewController.m
//  厨房宝典
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ChufangViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ChufangViewController ()

@end

@implementation ChufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"厨房宝典";
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    [self getDateload];
}
#pragma mark -------- 请求数据
- (void)getDateload{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*

 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
