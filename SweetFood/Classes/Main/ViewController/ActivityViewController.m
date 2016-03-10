//
//  ActivityViewController.m
//  视频详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"


@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *menutablew;

@end



@implementation ActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view.
    
    
    [self showBackButtonWithImage:@"back"];
    [self.view addSubview:self.menutablew];
    
    [self getMenuData];
}

- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    [manager GET:@"http://api.haodou.com/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1457493456063&vc=82&vn=6.0.3&loguid=0&deviceid=haodou864301020205370&uuid=f66340c09213f80b0219f01ce20219dd&channel=oppo_v603&method=Comment.getList&virtual=&signmethod=md5&v=2&timestamp=1457495739&nonce=0.4498857000808161&appsign=94419a2f2808b904890b230e91085b56&rid=1041181" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        
        
        
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellsteing = @"视频播放";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellsteing];
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellsteing];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

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
