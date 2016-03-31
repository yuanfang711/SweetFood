//
//  HotViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/31.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import "MianTableViewCell.h"
#import "StoryViewController.h"
@interface HotViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger _pageNum;
}
@property (nonatomic, strong) PullingRefreshTableView *pullTbaleView;
@property (nonatomic, strong) NSMutableArray *HotArray;
@property (nonatomic, assign) BOOL Refreshing;

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.pullTbaleView];
    [self.pullTbaleView launchRefreshing];
    _pageNum = 0;
    [self getHotData];
}
- (void)getHotData{
    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] init];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manage GET:[NSString stringWithFormat:@"http://api.haodou.com/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1459306430161&vc=82&vn=6.0.3&loguid=0&deviceid=haodou864301020205370&uuid=e71175d3b66b1841965ba633bf00f834&channel=oppo_v603&method=Video.getHotRankList&virtual=&signmethod=md5&v=2&nonce=0.31540568068809427&appsign=f932d806c584e5f80549488bff5a685e&offset=%ld",_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *root = responseObject;
        NSDictionary *datas = root[@"result"];
        NSArray *list = datas[@"list"];
        if (self.Refreshing ){
            if (self.HotArray.count > 0) {
                [self.HotArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in list) {
            [self.HotArray addObject:dic];
        }
        [self.pullTbaleView reloadData];
        [self.pullTbaleView tableViewDidFinishedLoading];
        self.pullTbaleView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
#pragma mark ------------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"cellss";
    MianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell == nil) {
        cell = [[MianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstring];
    }
    NSString *sting = self.HotArray[indexPath.row][@"Cover"];
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
    cell.titleLable.text = self.HotArray[indexPath.row][@"Title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HotArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryViewController *storyVC = [[StoryViewController alloc] init];
    storyVC.title = self.HotArray[indexPath.row][@"Title"];
    storyVC.videoId = self.HotArray[indexPath.row][@"VideoId"];
    [self.navigationController pushViewController:storyVC animated:YES];
}
#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.Refreshing = YES;
    _pageNum = 0;
    [self performSelector:@selector(getHotData) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.Refreshing = NO;
    _pageNum +=20;
    [self performSelector:@selector(getHotData) withObject:nil afterDelay:1.0];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pullTbaleView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pullTbaleView tableViewDidEndDragging:scrollView];
}
#pragma mark ------------- 懒加载
-(PullingRefreshTableView *)pullTbaleView{
    if (_pullTbaleView == nil) {
        _pullTbaleView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight-64) pullingDelegate:self];
        self.pullTbaleView.dataSource = self;
        self.pullTbaleView.delegate = self;
        self.pullTbaleView.rowHeight = kScreenhight/3+20;
        self.pullTbaleView.separatorColor = [UIColor clearColor];
    }
    return _pullTbaleView;
}

- (NSMutableArray *)HotArray{
    if (_HotArray == nil) {
        _HotArray = [NSMutableArray new];
    }
    return _HotArray;
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
