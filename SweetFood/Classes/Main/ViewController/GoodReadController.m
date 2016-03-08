//
//  GoodReadController.m
//  菜谱列表
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodReadController.h"
#import "GoodTableViewCell.h"

@interface GoodReadController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;


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
#pragma mark ---------- 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:@"http://api.haodou.com/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1457436095933&vc=82&vn=6.0.3&loguid=0&deviceid=haodou864301020205370&uuid=f66340c09213f80b0219f01ce20219dd&channel=oppo_v603&method=Info.getAlbumInfo&virtual=&signmethod=md5&v=2&timestamp=1457436177&nonce=0.6755273434561482&appsign=b981d7509c7cc28cedd703b6dd8a0246" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
//        NSDictionary *result = rootDic[@"result"];
        //广告数据
        //        NSDictionary *recipeDic = result[@"goods"];
        //        NSArray *adArray = recipeDic[@"list"];
        //
        //        for (NSDictionary *listDic in adArray) {
        //
        //            [self.goodArray addObject:listDic];
        //        }
        
        //热门专辑
//        NSDictionary *alDic = result[@"album"];
//        NSArray *alArray = alDic[@"list"];
//        for (NSDictionary *listDic in alArray) {
//            [self.hotArray addObject:listDic[@"Img"]];
//        }
        //
        //table数据
        
//        NSDictionary *event = result[@"recipe"];
//        NSArray *listArray = event[@"list"];
//        for (NSDictionary *listdic in listArray) {
//            MainModel *model = [[MainModel alloc] initWithNSDictionary:listdic];
//            [self.cellTwoArray  addObject:model];
//        }
//        [self.listArray addObject:self.cellTwoArray];
//        NSDictionary *person = result[@"person"];
//        NSArray *sonArray = person[@"tag"];
//        for (NSDictionary *listdic in sonArray) {
//            MianModel *model = [[MianModel alloc] initWithNSDictionary:listdic];
//            [self.cellArray addObject:model];
//        }
//        [self.listArray addObject:self.cellArray];
//        
//        [self.tableView reloadData];
//        [self setTableViewHeadView];
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
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}
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
