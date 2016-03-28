//
//  ActivityViewController.m
//  详情页面
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "HWTools.h"
@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat height;
}

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation ActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //返回按钮
    [self showBackButtonWithImage:@"back"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self getMenuData];
    [self detailsbutton];
    
}
+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kScreenWitch - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height;
}
//详情
- (void)detailsbutton{
    
    if (self.cellArray.count > 0) {
        self.headView.frame = CGRectMake(5, 5, kScreenWitch - 10, 480);
        UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, 240)];
        [ImageView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"Cover"]] placeholderImage:nil];
        //    ImageView.backgroundColor = [UIColor redColor];
        [self.headView addSubview:ImageView];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(10, 245, kScreenWitch, 35)];
        titleName.text = self.infoDic[@"Title"];
        //    titleName.backgroundColor = kViewColor;
        [self.headView addSubview:titleName];
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 283, kScreenWitch/2-20, 20)];
        dateLable.font = [UIFont systemFontOfSize:16.0];
        //    dateLable.backgroundColor = kViewColor;
        dateLable.text = self.infoDic[@"CreateTime"];
        [self.headView addSubview:dateLable];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 305, 40, 40)];
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"UserInfo"][@"Avatar"]] placeholderImage:nil];
        iconView.layer.cornerRadius = 20;
        iconView.clipsToBounds = YES;
        
        [self.headView addSubview:iconView];
        
        UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 305, kScreenWitch - 90, 40)];
        Name.text = self.infoDic[@"UserInfo"][@"UserName"];
        [self.headView  addSubview:Name];
        
        UILabel *introlLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, kScreenWitch-20, 100)];
        introlLable.numberOfLines = 0;
        introlLable.text = self.infoDic[@"Intro"];
        CGFloat heights = [[self class] getTextHeightWithText:introlLable.text];
        introlLable.font = [UIFont systemFontOfSize:13.0];
        CGRect frame = introlLable.frame;
        frame.size.height = heights;
        introlLable.frame = frame;
        [self.headView addSubview:introlLable];
        
        
        UILabel *tame = [[UILabel alloc] initWithFrame:CGRectMake(10, 350 + heights, kScreenWitch/2-40, 30)];
        tame.text = @"制作时间";
        [self.headView addSubview:tame];
        
        UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2-50, 350 + heights, kScreenWitch-60, 30)];
        //    workTimeL.backgroundColor = kViewColor;
        workTimeL.text = [NSString stringWithFormat:@"%@",self.infoDic[@"CookTime"]];
        [self.headView addSubview:workTimeL];
        CGRect headFrame = self.headView.frame;
        headFrame.size.height = heights + 380;
        self.headView.frame = headFrame;
  
        self.tableView.tableHeaderView = self.headView;
    }
}
//请求数据
- (void)getMenuData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"正在为你加载数据"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@&rid=%@",kMenuDetaills,self.fooDid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *rootDic = responseObject;
        NSDictionary *result = rootDic[@"result"];
        
        //详情
        
        self.infoDic = result[@"info"];
        //食材
        NSArray *stuffarray = self.infoDic[@"Stuff"];
        NSMutableArray *stuff = [NSMutableArray new];
        for (NSDictionary *dic in stuffarray) {
            [stuff addObject:dic];
        }
        [self.cellArray addObject:stuff];
        //步骤
        NSArray *steps = self.infoDic[@"Steps"];
        NSMutableArray *step = [NSMutableArray new];
        for (NSDictionary *dic  in steps) {
            [step addObject:dic];
        }
        [self.cellArray addObject:step];
        [self.tableView reloadData];
        [self detailsbutton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cella = @"stuff";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cella];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cella];
            NSMutableArray *group = self.cellArray[indexPath.section];
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWitch/2-5, 20)];
            name.textColor = [UIColor grayColor];
            name.text = group[indexPath.row][@"name"];
            
            
            UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2+15, 5, kScreenWitch/2-5, 20)];
            self.tableView.separatorColor = [UIColor blackColor];
            weight.text =  group[indexPath.row][@"weight"];
            weight.textColor = [UIColor grayColor];
            //            self.tableView.rowHeight = 30;
            [cell addSubview:name];
            [cell addSubview:weight];
            //            self.tableView.rowHeight = 30;
            //            cell.backgroundColor = [UIColor cyanColor];
        }
        return cell;
    }
    else {
        static NSString *cellView = @"step";
        UITableViewCell *viewcell = [tableView dequeueReusableCellWithIdentifier:cellView];
        if (viewcell == nil) {
            viewcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellView];
            self.tableView.separatorColor = [UIColor clearColor];
            NSMutableArray *group = self.cellArray[indexPath.section];
            if (indexPath.row < group.count) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kScreenWitch/3, kScreenWitch/3-20)];
                
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/3+20, 5, kScreenWitch-kScreenWitch/3-30,  kScreenWitch/3-20 )];
                name.font = [UIFont systemFontOfSize:14.0];
                name.numberOfLines = 0;
                name.text = group[indexPath.row][@"Intro"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:group[indexPath.row][@"StepPhoto"]] placeholderImage:nil];
                [viewcell addSubview:imageView];
                [viewcell addSubview:name];
            }
        }
        return viewcell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *group = self.cellArray[section];
    if (section == 0) {
        return group.count;
    }
    else
        return group.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }
    if (indexPath.section == 1) {
        return kScreenWitch/3-10;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"食材";
    }else{
        return @"步骤";
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (section == 0) {
//        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
//        UILabel *title = [[UILabel alloc] initWithFrame:view.frame];
//        title.text = @"食材";
//        [view addSubview:title];
//        view.backgroundColor = [UIColor whiteColor];
//    }else{
//        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
//        UILabel *title = [[UILabel alloc] initWithFrame:view.frame];
//        title.text = @"步骤";
//        [view addSubview:title];
//        view.backgroundColor = [UIColor whiteColor];
//
//    }
//            return view;
//}

#pragma mark ---------- 懒加载
- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
}

- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, kScreenWitch- 10, kScreenhight-10) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //        self.tableView.separatorColor = kViewColor;
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
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
