//
//  AppDelegate.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "AppUtils.h"
#import "LQRootViewCtrl.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark  ===  生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 开机初始化
    [AppUtils appInitial];
    
    // 友盟初始化
    [self initUM];
    
    // window 初始化
    [self initWindow];
    
//    [self coverMaskView];
    
    return YES;
}



//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    [self coverMaskView];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    [self recoverMaskView];
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [self recoverMaskView];
//}

#pragma mark ==== 跳转
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [self um_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];  // 友盟处理
    if (!result) {
        
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [self um_application:app openURL:url options:options]; // 友盟处理
    if (!result) {
        
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [self um_application:application handleOpenURL:url]; // 友盟处理
    if (!result) {
        
    }
    return result;
}

@end
