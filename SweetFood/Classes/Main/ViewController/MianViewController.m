//
//  MianViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianViewController.h"
#import "MianTableViewCell.h"
#import "HomeViewController.h"
#import "MovieViewController.h"
#import "ChufangViewController.h"
#import "GoodReadController.h"
#import "ActivityViewController.h"
#import "HotThemeController.h"
#import "MainModel.h"
#import "MianModel.h"
#import "GoodModel.h"
#import "TodayViewController.h"
@interface MianViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//tableview的头视图
@property (strong, nonatomic) UIView *headView;
//广告的视图
@property (strong, nonatomic) UIView *headSView;
//列表视图
@property (strong, nonatomic) UIView *toolView;
//热门专辑视图
//@property (strong, nonatomic) UIView *hotView;



//数据 ：热门专辑
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *goodArray;
@property (nonatomic, strong) NSMutableArray *cellTwoArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *hotArray;

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"菜谱";
    //    //注册cell
    //    [self.tableView registerNib:[UINib nibWithNibName:@"MianTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //设置tableView的头视图
    [self setTableViewHeadView];
    
    self.view.userInteractionEnabled  = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //请求数据
    [self getDataLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark ------------ 数据请求
- (void)getDataLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    [manager GET:kMainDatd parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        //广告数据
        //        NSDictionary *recipeDic = result[@"goods"];
        //        NSArray *adArray = recipeDic[@"list"];
        //
        //        for (NSDictionary *listDic in adArray) {
        //
        //            [self.goodArray addObject:listDic];
        //        }
        
        //热门专辑
        NSDictionary *alDic = result[@"album"];
        NSArray *alArray = alDic[@"list"];
        for (NSDictionary *listDic in alArray) {
            [self.hotArray addObject:listDic];
        }
        //
        //table数据
        
        NSDictionary *event = result[@"recipe"];
        NSArray *listArray = event[@"list"];
        for (NSDictionary *listdic in listArray) {
            MainModel *model = [[MainModel alloc] initWithNSDictionary:listdic];
            [self.cellTwoArray  addObject:model];
        }
        [self.listArray addObject:self.cellTwoArray];
        NSDictionary *person = result[@"person"];
        NSArray *sonArray = person[@"tag"];
        for (NSDictionary *listdic in sonArray) {
            MianModel *model = [[MianModel alloc] initWithNSDictionary:listdic];
            [self.cellArray addObject:model];
        }
        [self.listArray addObject:self.cellArray];
        
        [self.tableView reloadData];
        [self setTableViewHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark ********** 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"ios";
    MianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell == nil) {
        cell = [[MianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstring];
    }
    NSMutableArray *groip = self.listArray[indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row < groip.count ) {
            MainModel*model = groip[indexPath.row];
            cell.mainModel = model;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row < groip.count ) {
            MianModel*mainModel = groip[indexPath.row];
            cell.model = mainModel;
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *group = self.listArray[section];
    return group.count;
    //    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"热门专辑";
    }else
        return @"猜你喜欢";
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return <#expression#>;
//    }
//    if (indexPath.section == 1) {
//        return 200;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MainModel *model= self.cellTwoArray[indexPath.row];
        NSString *idstring = model.url;
        NSArray *idarray = [idstring componentsSeparatedByString:@"com/"];
        NSString *com = idarray[1];
        NSArray *celltype = [com componentsSeparatedByString:@"/"];
        if (celltype.count == 2) {
            NSString *url = celltype[celltype.count - 1];
            NSArray *homeurl = [url componentsSeparatedByString:@"url="];
            NSString *Homeurl = homeurl[1];
            NSArray *htmlurl = [Homeurl componentsSeparatedByString:@"%2F"];
     
            HotThemeController *hotVC = [[HotThemeController alloc] init];
            if ([celltype[0]isEqualToString:@"openurl"]) {
                hotVC.htmlUrl = [NSString stringWithFormat:@"http://%@/%@",htmlurl[htmlurl.count - 2],htmlurl[htmlurl.count - 1]];
            }
            if ([celltype[0]isEqualToString:@"opentopic"]) {
                NSString *homlid = htmlurl[htmlurl.count - 1];
                NSArray *htmlid = [homlid componentsSeparatedByString:@"&id"];
                hotVC.htmlUrl = [NSString stringWithFormat:@"http://%@/%@?_v=nohead",htmlurl[htmlurl.count - 2],htmlid[0]];
            }
            
            hotVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hotVC animated:YES];
            
        }else{
            NSString *main = celltype[2];
            NSArray *mainarray = [main componentsSeparatedByString:@"="];
            NSString *mainID = mainarray[1];
            if ([celltype[0] isEqualToString:@"goods"]) {
                TodayViewController *todaVC = [[TodayViewController alloc] init];
                
                todaVC.todayId = mainID;
                todaVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:todaVC animated:YES];
            }if([celltype[0] isEqualToString:@"recipe"]){
                ActivityViewController *actiVC = [[ActivityViewController alloc ]init];
                            actiVC.fooDid = mainID;
                actiVC.title = model.title;
                [self.navigationController pushViewController:actiVC animated:YES];
            }
            
            if([celltype[0] isEqualToString:@"collect"]){
                GoodReadController *GoodVC = [[GoodReadController alloc] init];
                            GoodVC.goodId = mainID;
                GoodVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:GoodVC animated:YES];
            }
                 
        }
        
  /*
        if (indexPath.row == 0) {
            TodayViewController *todaVC = [[TodayViewController alloc] init];
            
//            todaVC.todayId = mainID;
            todaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:todaVC animated:YES];
        }
        if (indexPath.row == 1) {
            GoodReadController *GoodVC = [[GoodReadController alloc] init];
//            GoodVC.goodId = mainID;
            GoodVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:GoodVC animated:YES];
        }
        if (indexPath.row == 2) {
            HotThemeController *hotVC = [[HotThemeController alloc] init];
            hotVC.htmlUrl = @"http://m.haodou.com/topic-428563.html?_v=nohead";
            hotVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hotVC animated:YES];
        }
        if (indexPath.row == 3) {
            GoodReadController *GoodVC = [[GoodReadController alloc] init];
//            GoodVC.goodId = mainID;
            GoodVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:GoodVC animated:YES];
        }
        if (indexPath.row == 4) {
            GoodReadController *GoodVC = [[GoodReadController alloc] init];
//            GoodVC.goodId = mainID;
            GoodVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:GoodVC animated:YES];
        }
        if (indexPath.row == 5) {
            HotThemeController *hotVC = [[HotThemeController alloc] init];
            hotVC.htmlUrl = @"http://m.haodou.com/topic-409935.html?_v=nohead";
            hotVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hotVC animated:YES];
   
   http://m.vatti.com.cn/activity-1168.html
   
   http://m.haodou.com/topic-428563.html?_v=nohead
        }
        if (indexPath.row == 6||indexPath.row == 7) {
           ActivityViewController *actiVC = [[ActivityViewController alloc ]init];
//            actiVC.fooDid = mainID;
            actiVC.title = model.title;
            [self.navigationController pushViewController:actiVC animated:YES];
        } */
   }
   
    if (indexPath.section == 1) {
        ChufangViewController *chuVC = [[ChufangViewController alloc] init];
        chuVC.modelNum = [NSNumber numberWithInt:1];
//        chuVC.getUrl = kLove;
        MianModel *model = self.cellArray[indexPath.row];
        chuVC.modelId = model.cateId;
        chuVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chuVC animated:YES];
    }
}

#pragma mark -----------  设置区头
- (void)setTableViewHeadView{
    self.headView.backgroundColor = kViewColor;
    
    UIImageView *views = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kScreenWitch-20,145)];
    [views sd_setImageWithURL:[NSURL URLWithString:@"http://img1.hoto.cn/haodou/recipe_mobile_ad/2016/03/1457058057.jpg"] placeholderImage:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = self.headSView.frame;
    [button addTarget:self action:@selector(LoveAction) forControlEvents:UIControlEventTouchUpOutside];
    [button addSubview:views];
    [self.headSView addSubview:button];
    [self.headView addSubview:self.headSView];
    
    //列表
    [self toolViewChange];
    //热门专辑
    //    [self hotTheme];
//    self.hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 205, kScreenWitch, 125)];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kScreenWitch - 20, 20)];
//    title.text = @"热门专辑";
//    [self.hotView addSubview:title];
//    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.frame = CGRectMake(15, 35, kScreenWitch /2 - 15, 98);
//    [left addTarget:self action:@selector(zhuanjiAction) forControlEvents:UIControlEventTouchUpInside];
////    [left setBackgroundColor:[UIColor redColor]];
//    left.tag = 0;
//    [self.hotView addSubview:left];
//    UIImageView *viewIcon = [[UIImageView alloc] init];
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    right.frame = CGRectMake(kScreenWitch /2 + 10, 35, kScreenWitch /2 - 25, 98);
//    [right addTarget:self action:@selector(zhuanjiAction) forControlEvents:UIControlEventTouchUpInside];
////    [right setBackgroundColor:[UIColor redColor]];
//    right.tag = 1;
//    for (int i = 0; i< self.hotArray.count; i++) {
//        //        MianModel *model= self.hotArray[i];
//        if (i == 0) {
//            [viewIcon sd_setImageWithURL:[NSURL URLWithString:self.hotArray[i]] placeholderImage:nil];
//            viewIcon.backgroundColor = [UIColor orangeColor];
//            viewIcon.frame = left.frame;
//            [left addSubview:viewIcon];
//        }
//        if (i == 1) {
//            [viewIcon sd_setImageWithURL:[NSURL URLWithString:self.hotArray[i]] placeholderImage:nil];
//                viewIcon.backgroundColor = [UIColor orangeColor];
//            viewIcon.frame = right.frame;
//            [right addSubview:viewIcon];
//        }
//    }
//    [self.hotView addSubview:right];
//    [self.headView addSubview:self.hotView];
    
    [self.headView addSubview:self.toolView];

    
    self.tableView.tableHeaderView = self.headView;
}

//列表内容
- (void)toolViewChange{
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWitch, 55)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    
    //列表
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(5, 0, kScreenWitch / 3 - 10, 55);
    [foodButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    foodButton.tag = 100;
    UIImageView *food = [[UIImageView alloc] initWithFrame:CGRectMake(foodButton.frame.size.width/3 - 5, 0, 40, 40)];
    food.image = [UIImage imageNamed:@"meishi.png"];
    UILabel *foodLable = [[UILabel alloc] initWithFrame:CGRectMake(foodButton.frame.size.width/3 - 8, 40, foodButton.frame.size.width/3 + 8, 15)];
    foodLable.text = @"美食汇";
    foodLable.textColor = [UIColor orangeColor];
    foodLable.textAlignment = NSTextAlignmentCenter;
    foodLable.font = [UIFont systemFontOfSize:13.0];
    [foodButton addSubview:food];
    [foodButton addSubview:foodLable];
    
    UIButton *movieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    movieButton.frame = CGRectMake(kScreenWitch / 3 + 5, 3, kScreenWitch / 3 - 10,55);
    [movieButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    movieButton.tag = 101;
    UIImageView *movie = [[UIImageView alloc] initWithFrame:CGRectMake(movieButton.frame.size.width/3 - 5, 0,40, 40)];
    movie.image = [UIImage imageNamed:@"shiping.png"];
    UILabel *movieL = [[UILabel alloc] initWithFrame:CGRectMake(movieButton.frame.size.width/3 - 8, 40, movieButton.frame.size.width/3 + 8, 15)];
    movieL.text = @"视频";
    movieL.textColor = [UIColor greenColor];
    movieL.textAlignment = NSTextAlignmentCenter;
    movieL.font = [UIFont systemFontOfSize:13.0];
    [movieButton addSubview:movieL];
    [movieButton addSubview:movie];
    
    
    UIButton *chuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chuButton.frame = CGRectMake(kScreenWitch / 3 * 2 + 5, 2, kScreenWitch / 3  - 10, 55);
    [chuButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    chuButton.tag = 102;
    UIImageView *chu = [[UIImageView alloc] initWithFrame:CGRectMake(chuButton.frame.size.width/3 - 5, 0, 40, 40)];
    chu.image = [UIImage imageNamed:@"chufang.png"];
    UILabel *chuLable = [[UILabel alloc] initWithFrame:CGRectMake(chuButton.frame.size.width/3 - 15, 40, chuButton.frame.size.width/3 + 20, 15)];
    chuLable.text = @"厨房宝典";
    chuLable.textColor = [UIColor orangeColor];
    chuLable.textAlignment = NSTextAlignmentCenter;
    chuLable.font = [UIFont systemFontOfSize:12.0];
    [chuButton addSubview:chu];
    [chuButton addSubview:chuLable];
    
    [self.toolView addSubview:foodButton];
    [self.toolView addSubview:movieButton];
    [self.toolView addSubview:chuButton];
}

- (void)LoveAction{
    HotThemeController *hotVC = [[HotThemeController alloc] init];

    hotVC.htmlUrl = @"http://m.haodou.com/mall/index.php?r=wap/weixin/womenday2nd";
    hotVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotVC animated:YES];
}

//热门专辑
//- (void)hotTheme{
//
//}

#pragma mark -------- 点击方法
- (void)toolAction:(UIButton *)button{
    if (button.tag == 100) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"HomaVC" bundle:nil];
        HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomaVC"];
        [self.navigationController pushViewController:homeVC animated:YES];
    }
    if (button.tag == 101) {
        MovieViewController *movieVC = [[MovieViewController alloc] init];
        movieVC.hidesBottomBarWhenPushed = YES;
        movieVC.title = @"视频菜谱";
        [self.navigationController pushViewController:movieVC animated:YES];
    }
    if (button.tag == 102) {
        ChufangViewController *chuVC = [[ChufangViewController alloc] init];
        chuVC.getUrl = kChuData;
        chuVC.modelNum = [NSNumber numberWithInt:0];
        chuVC.title = @"厨房宝典";
        chuVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chuVC animated:YES];
    }
}
#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];
        self.tableView.separatorColor = [UIColor brownColor];
        self.tableView.rowHeight = 190;
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch-10, 210)];
    }
    return _headView;
}

- (UIView *)headSView{
    if (_headSView == nil) {
        _headSView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWitch - 15, 145)];
    }
    return _headSView;
}
- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [[UIView alloc] init];
    }
    return _toolView;
}
//- (UIView *)hotView{
//    if (_hotView == nil) {
//        _hotView = [[UIView alloc] init];
//    }
//    return _hotView;
//}

- (NSMutableArray *)goodArray{
    if (_goodArray == nil) {
        _goodArray = [NSMutableArray new];
    }
    return _goodArray;
}
- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
}
- (NSMutableArray *)cellTwoArray{
    if (_cellTwoArray == nil) {
        _cellTwoArray = [NSMutableArray new];
    }
    return _cellTwoArray;
}
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        _hotArray = [NSMutableArray new];
    }
    return _hotArray;
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
