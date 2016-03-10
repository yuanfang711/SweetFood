//
//  GoodReadController.m
//  菜谱列表
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodReadController.h"
#import "GoodTableViewCell.h"
#import "GoodModel.h"
@interface GoodReadController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation GoodReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    
    self.tableView.sectionIndexColor = [UIColor grayColor];
    
    [self.view addSubview:self.tableView];
    [self getDataLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark ---------- 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [NSString stringWithFormat:@"%@%@",kGoodTool,self.goodId]
    [manager GET:[NSString stringWithFormat:@"%@%@",kGoodTool,self.goodId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //头数据
        NSDictionary *recipeDic = result[@"info"];
        [self.infoArray addObject:recipeDic];

        
        //列表
        NSArray *alArray = result[@"list"];
        for (NSDictionary *listDic in alArray) {
            GoodModel *model = [[GoodModel alloc] initWithNSDictionary:listDic];
            [self.listArray addObject:model];
        }
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    GoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell== nil) {
        cell = [[GoodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    cell.goodModel = self.listArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
#pragma mark ---------- 点击方法
#pragma mark ---------- 懒加载
- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 230;
        self.tableView.sectionIndexColor = [UIColor brownColor];
    }
    return _tableView;
}

//
//- (UIView *)headView{
//    if
//}


- (NSMutableArray *)listArray{
    if ( _listArray == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)infoArray{
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray new];
    }
    return _infoArray;
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
