//
//  ShopViewController.m
//  SweetFood
//
//  Created by scjy on 16/3/11.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackButtonWithImage:@"back"];
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark --------- 区头设置
//详情
- (void)detailsbutton{
    if (self.cellArray.count > 0) {
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
        
        //    iconView.backgroundColor = kViewColor;
        [self.headView addSubview:iconView];
        
        UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(60, 305, kScreenWitch - 90, 40)];
        //    Name.backgroundColor = kViewColor;
        Name.text = self.infoDic[@"UserInfo"][@"UserName"];
        [self.headView  addSubview:Name];
        
        UILabel *introlLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, kScreenWitch-20, 100)];
        introlLable.numberOfLines = 0;
        introlLable.text = self.infoDic[@"Intro"];
        //    introlLable.backgroundColor = kViewColor;
        introlLable.font = [UIFont systemFontOfSize:15.0];
        [self.headView addSubview:introlLable];
        
        
        UILabel *tame = [[UILabel alloc] initWithFrame:CGRectMake(10, 453, kScreenWitch/2-40, 30)];
        tame.text = @"制作时间";
        [self.headView addSubview:tame];
        
        UILabel *workTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch/2-50, 453, kScreenWitch-60, 30)];
        //    workTimeL.backgroundColor = kViewColor;
        workTimeL.text = [NSString stringWithFormat:@"%@",self.infoDic[@"CookTime"]];
        [self.headView addSubview:workTimeL];
    }
}
#pragma mark --------- 数据请求

#pragma mark --------- 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cella = @"shop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cella];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cella];
        cell.backgroundColor = [UIColor cyanColor];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark ---------- 懒加载
- (NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary new];
    }
    return _infoDic;
}

- (UITableView *)tableView{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //        self.tableView.separatorColor = kViewColor;
//        self.tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWitch - 10, 480)];
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
