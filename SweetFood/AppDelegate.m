//
//  AppDelegate.m
//  SweetFood
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "AppDelegate.h"
#import "MianViewController.h"
#import "MineViewController.h"
#import "MovieViewController.h"
#import "TabbarViewController.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:KAppkey];

    //创建BmobKoey
    [Bmob registerWithAppKey:@"b8c3db171106c6548b779c695ec730d2"];
    
    //创建
    TabbarViewController *tabbarC = [[TabbarViewController alloc] init];
    self.window.rootViewController = tabbarC;
    tabbarC.tabBar.tintColor = [UIColor orangeColor];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
   
}
//
//-(void)onReq:(BaseReq *)req{
//    
//}
//-(void)onResp:(BaseResp *)resp{
//    
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
        return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
        return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
