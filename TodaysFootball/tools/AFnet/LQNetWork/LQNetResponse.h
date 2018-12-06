//
//  LQNetResponse.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LQNetResponseCode) {
    kLQNetResponseSuccess                                       = 0,
    kLQNetResponseTKOverdue                                = 2,       // token 过期
    kLQNetResponseNeedLogin                                  = 102,    // 需要登录
    kLQNetResponseGetVerifycodeError                = 1006,    // 发送验证码失败, 重新申请发送
    kLQNetResponseVerifycodeInconformity          = 1007,    // 验证码错误, 建议确认验证码后重试
    kLQNetResponsePasswordError                          =  1101,  // 密码错误 ， 登陆时密码错误
    kLQNetResponseUserUnknown                           = 1102 ,  // 登陆时无法找到用户
    kLQNetResponseHasBinding                                = 1103,  // 手机号已经绑定
    kLQNetResponseBalanceNotEnough                = 1201,  // 余额不足
    kLQNetResponsePlanIDError                              = 1202,  // 方案错误，threadid错误
    kLQNetResponseNonPurchase                            = 1203,  // 方案不可购买， plock == 3
    kLQNetResponsePurchased                                 = 1204,  // 此方案已购买
    kLQNetResponseCouponError                           = 1205,  // 优惠券错误
    kLQNetResponseOrderIDError                          = 1305,  // 订单未找到，确认 iapOrderId 参数是否正确
    kLQNetResponseOrderCheckTimeOut           = 1306,  // 订单校验超时
    kLQNetResponseOrderCheckFailed                 = 1307,  // 订单校验次数过多，不用校验了
    kLQNetResponseNonMatch                                 = 1401,  // 无法获取赛事信息
};

typedef NS_ENUM(NSInteger, LQNetErrorCode) {
    kLQNetErrorCodeFaild = 100,  // 请求失败
    kLQNetErrorCodeNotReachable,   // 本地错误，没有网络
    kLQNetErrorCodeNeedGetBoot = 401,  // 需要重新请求开机接口
};

/**
 网络数据解析基类
 */
@interface LQNetResponse : NSObject<LQDecode>
/**
 回调状态 ，0表示成功
 */
@property (nonatomic) LQNetResponseCode  ret;
/**
 提示
 */
@property (nonatomic, copy) NSString *msg;

/**
 * 数据字典，子类对data进行解析
 * 也可能是数组
 */
@property (nonatomic) id data;

@end
