//
//  LoginViewController.m
//  SweetFood
//
//  Created by scjy on 16/4/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "LoginViewController.h"
#import "TabbarViewController.h"
#import "LPLevelView.h"
#import "UIViewController+Common.h"
#import <BmobSDK/BmobUser.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UIView *headview;
@property (nonatomic, strong) UIView *score1;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, strong) UIView *grayView;
@end

@implementation LoginViewController
-(void)viewDidAppear:(BOOL)animated{
    //大小
    SDImageCache *chche = [SDImageCache sharedImageCache];
    
    NSUInteger chachesize = [chche getSize];
    
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.2fM)",(float)chachesize/1024/1204];
    //使用替换，不能用插入，替换得出新写的数据。插入使原有的数组的个数多一个
    [self.cellArray replaceObjectAtIndex:0 withObject:cacheStr];
    //cell的位置；
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //刷新单行的cell
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cellArray = [NSMutableArray arrayWithObjects:@"清除缓存",@"应用评分",@"推荐好友",nil];
    [self.view addSubview:self.tableView];
    self.headview.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:194.0/255.0 blue:151.0/255.0 alpha:1.0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.headview.frame];
    imageView.image = [UIImage imageNamed:@"11111"];
    [self.headview addSubview:imageView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch /5*2 + 5,imageView.frame.size.height/3,kScreenWitch /5 - 10, kScreenWitch /5-10)];
    name.font = [UIFont systemFontOfSize:20.0];
    name.textAlignment = NSTextAlignmentCenter;
    name.backgroundColor = [UIColor whiteColor];
    name.layer.cornerRadius = 10;
    name.layer.masksToBounds = YES;
    name.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    name.textColor = [UIColor orangeColor];
    [imageView addSubview:name];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch /6,imageView.frame.size.height/2 + 20,kScreenWitch - kScreenWitch /6*2 , imageView.frame.size.height -imageView.frame.size.height/2 -20)];
    lable.font = [UIFont systemFontOfSize:18.0];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
    lable.text = @"欢迎进入甜馨美食，开启你的美食之旅吧！";
    lable.numberOfLines = 0;
    lable.textColor = [UIColor whiteColor];
    [imageView addSubview:lable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWitch /3, kScreenhight-100, kScreenWitch/3, 30);
    [button setTitle:@"退出账户" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:169.0/255.0 blue:98.0/255.0 alpha:1.0]];
    [button addTarget:self action:@selector(userGoOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)userGoOutAction{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =[ UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
        [login removeObjectForKey:@"name"];
        TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
        tabbarVC.selectedIndex = 2;
        self.view.window.rootViewController = tabbarVC;
        tabbarVC.tabBar.tintColor = [UIColor orangeColor];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark ------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.cellArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //找到存储的位置NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            //清除里面添加的图片
            SDImageCache *image = [SDImageCache sharedImageCache];
            //调用方法，清除所有一起拿存储的图片
            [image clearDisk];
            [self.cellArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"清除缓存(%.0fM)",(float)[image getSize]]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            //刷新单行的cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case 1:
        {
            self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight)];
            self.grayView.backgroundColor = [UIColor blackColor];
            self.grayView.alpha = 0.5;
            [self.view addSubview:self.grayView];
            
            self.score1 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenhight/2, kScreenWitch,kScreenhight)];
            self.score1.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.score1];
            
            UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            removeBtn.frame = CGRectMake(20,kScreenWitch/2, kScreenWitch -  40,40);
            [removeBtn setTitle:@"给我评分" forState:UIControlStateNormal];
            [removeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [removeBtn addTarget:self action:@selector(last ) forControlEvents:UIControlEventTouchUpInside];
            //            removeBtn.backgroundColor = kColor;
            [self.score1 addSubview:removeBtn];
            
            LPLevelView *lView = [LPLevelView new];
            lView.frame = CGRectMake(kScreenWitch/3,kScreenWitch/4,kScreenWitch/3,44);
            lView.iconColor = [UIColor orangeColor];
            lView.iconSize = CGSizeMake(20, 20);
            lView.canScore = YES;
            lView.animated = YES;
            lView.level = 3.5;
            [lView setScoreBlock:^(float level) {
                self.level = level;
            }];
            [self.score1 addSubview:lView];
        }
            break;
        default:
            break;
    }
}
-(void)last{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要评分吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"评分成功" message:@"感谢您的支持" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [self.score1 removeFromSuperview];
            //            [self.grayView removeFromSuperview];
            self.score1.hidden = YES;
            self.grayView.hidden = YES;
            NSString *score = [NSString stringWithFormat:@"给我评分（%lu分）",(unsigned long)self.level];
            [self.cellArray replaceObjectAtIndex:1 withObject:score];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alert1 addAction:action1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -------  懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/2 + kScreenhight/4) style:UITableViewStylePlain];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.tableHeaderView = self.headview;
    }
    return _tableView;
}
- (UIView *)headview{
    if (_headview == nil) {
        self.headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWitch, kScreenhight/3)];
    }
    return  _headview;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        self.cellArray = [NSMutableArray new];
    }
    return _cellArray;
}

//点击换行见回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


//点击空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //或者点击除三个输入框外的地方
    //    [self.userName resignFirstResponder];
    //    [self.passText resignFirstResponder];
    //    [self.assginPassText resignFirstResponder];
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
