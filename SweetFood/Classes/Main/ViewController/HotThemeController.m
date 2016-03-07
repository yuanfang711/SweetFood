//
//  HotThemeController.m
//  活动详情---网页
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HotThemeController.h"
#import "UIViewController+Common.h"
@interface HotThemeController ()<UIWebViewDelegate>
//@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HotThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self showBackButtonWithImage:@"back"];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    webView.frame = CGRectMake(0, 0, kScreenWitch, kScreenhight );
    NSURL *url = [NSURL URLWithString:self.htmlUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
http://m.haodou.com/topic-428563.html?_v=nohead
 http://m.haodou.com/topic-431111.html?_v=nohead
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
