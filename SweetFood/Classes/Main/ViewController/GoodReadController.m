//
//  GoodReadController.m
//  菜谱列表
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodReadController.h"
#import "GoodTableViewCell.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodReadController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;


@end

@implementation GoodReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark ---------- 数据请求





#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    GoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell== nil) {
        cell = [[GoodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark ---------- 点击方法
#pragma mark ---------- 懒加载
- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight - 64) style:UITableViewStylePlain];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.sectionIndexColor = [UIColor brownColor];
    }
    return _tableView;
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
