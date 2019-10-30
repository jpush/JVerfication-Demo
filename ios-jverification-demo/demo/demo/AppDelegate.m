//
//  AppDelegate.m
//  demo
//
//  Created by ayy on 2018/10/21.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "AppDelegate.h"
#import "JVERIFICATIONService.h"
#import "JSHAREService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //集成极光认证sdk
    JVAuthConfig *config = [[JVAuthConfig alloc] init];
    config.appKey = @"填入在极光官网申请的AppKey";

    
    [JVERIFICATIONService setupWithConfig:config];
    [JVERIFICATIONService setDebug:YES];
    [self shareSDKConfig];
    return YES;
}

- (void)shareSDKConfig{
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = @"a0e6ace8d5b3e0247e3f58db";
    config.WeChatAppId = @"wx4a58c62d258121ac";
    config.WeChatAppSecret = @"6f43e3fca5b2c3996c20faf5c2a08729";

    config.SinaWeiboAppKey = @"2906641376";
    config.SinaWeiboAppSecret = @"b495eedd2ac836895eb06c971e521073";
    
    config.SinaRedirectUri = @"https://www.jiguang.cn";
    config.QQAppId = @"101789350";
    config.QQAppKey = @"8bd761ec8be03a0c75477ad1d4eb2a03";
    config.isSupportWebSina = YES;
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [JSHAREService handleOpenUrl:url];
    return YES;
}

@end
