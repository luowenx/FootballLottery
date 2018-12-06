//
//  AppDelegate+UM.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/18.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "AppDelegate.h"

#import <UMShare/UMShare.h>

#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
//#import <UMSocialCore/UMSocialCore.h>    // 分享组件
#import <UMPush/UMessage.h>             // Push组件
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (UM)

-(void)initUM
{
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES];    // debug: only for console log, must be remove in release version
#endif
    /*
     *  appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）
     */
    [UMConfigure initWithAppkey:@"5afbde938f4a9d7b990001b5" channel:nil];
    
    // 防止重复授权
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
    
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    
    // Share's setting
    [self setupUSharePlatforms];   // required: setting platforms on demand
//    [self setupUShareSettings];

}

// 支持所有iOS系统
- (BOOL)um_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)um_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];

    
    return result;
}

- (BOOL)um_application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];

    
    return result;
}


- (void)setupUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5d47ca876a8dfdb8" appSecret:@"88fcd1e1aa86a0b109a1aa3ac39f08d5" redirectURL:nil];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id  1106618298
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106835983"/*设置QQ平台的appID*/  appSecret:@"KEYgGG03aa8Qw6isgtb" redirectURL:nil];
    
    //  分享不使用Httpss
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}


- (void)setupUShareSettings
{

}


@end
