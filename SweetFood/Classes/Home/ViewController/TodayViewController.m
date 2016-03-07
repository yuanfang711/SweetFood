//
//  TodayViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//
/*
 http://api.haodou.com/mall/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1457322096694&vc=83&vn=6.1.0&loguid=0&deviceid=haodou866656021957511&uuid=e6cbc5ed186438c278364ed41078a110&channel=huawei_v610&method=collect.goodslist&virtual=&signmethod=md5&v=2&timestamp=1457322137&nonce=0.907562864652508&appsign=c378312a8d54542f3a00db6978c7af08
 */
#import "TodayViewController.h"
#import "TodayTableViewCell.h"
#import "TodayModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>


@interface TodayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"今日特价";
    
    
    [self.view addSubview:self.tableView];
}


#pragma mark -------- 请求数据
- (void)getDateload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:kChuData parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
//        NSDictionary *result = dic[@"result"];
//        NSArray *list = result[@"list"];
//        
//        for (NSDictionary *listDic in list) {
//            ChuModer *model = [[ChuModer alloc] initWithNSDictionary:listDic];
//            [self.listArray addObject:model];
//        }
//        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    cell.model = self.listArray[indexPath.row];
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 105;
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
