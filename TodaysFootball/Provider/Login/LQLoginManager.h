//
//  LQLoginManager.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/3.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LQLoginErrorCode) {
    kLQLoginErrorCodeNoInstallWX = 100,   // 未安装微信
    kLQLoginErrorCodeNoInstallQQ,
    kLQLoginErrorCodeInstallEnterEnterForeground,   
};

/**
 *  登录
 */
@interface LQLoginManager : NSObject

@property (nonatomic, strong, readonly, class) LQLoginManager * loginManager;

/**
 登陆接口统一调用
 
 @param ty 登陆类型
 @param aParameters 手机号登陆需传  phone 和 password
 @param callBack 回调
 */
-(void)loginWithType:(LQLoginWayType)ty aParameters:(NSDictionary *)aParameters callBack:(void(^)(BOOL success, NSError *error))callBack;


@end
