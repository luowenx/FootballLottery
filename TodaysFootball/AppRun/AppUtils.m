//
//  AppUtils.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "AppUtils.h"
#import "LQAppConfiger.h"
#import "AFNetworkReachabilityManager.h"
//#import<LequPay/LequPay.h>
//#import "LequPay.h"
#import <LequPay/LequPay.h>

@implementation AppUtils

+ (void)appInitial
{
    // 网络监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //  开机接口
    [[LQAppConfiger shareInstance] boot];
    
    // 获取用户信息
    [userManager getUsers];
    
}

@end

@implementation AppUtils (info)

+(NSString *)bundleName
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary] ;
    return dict[@"CFBundleDisplayName"];
}

+(NSString *)bundleShortVersion
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary] ;
    return dict[@"CFBundleShortVersionString"];
}

+(NSString *)bundleVersion
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary] ;
    return dict[@"CFBundleVersion"];
}

+(NSString *)bundleid
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary] ;
    return dict[@"CFBundleIdentifier"];
}

@end

