//
//  LQPayProtocol.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LQPayDelegateType)  {
    kLQPayDelegateTypeUnableToMakePayments, // 不支持支付
    kLQPayDelegateTypeWillRequestProductInfo, // 开始请求商品信息
    kLQPayDelegateTypeRequestProductInfoSuccess, // 商品信息请求成功
    kLQPayDelegateTypeRequestProductInfoFailure, // 商品信息请求失败
    kLQPayDelegateTypePayCanceled, // 取消支付
    kLQPayDelegateTypePaySuccess, // 支付成功
    kLQPayDelegateTypePayFailure, // 支付失败
    kLQPayDelegateTypeConfirmOrderSuccess, // 订单确认成功
    kLQPayDelegateTypeConfirmOrderFailure, // 订单确认失败
};

typedef void(^LQPayCallBack)(BOOL isContinue, LQPayDelegateType status);

@class LQProduct;
@protocol LQPayProtocol <NSObject>

@required
/**
 所支付的产品
 */
@property (nonatomic, strong) LQProduct * product;

/**
 支付方法调用
 
 @param callBack 回调
 */
-(void)payCallBack:(LQPayCallBack)callBack;

@optional
/**
 是否能支持该支付
 */
+(BOOL)canPay;

/**
 支付结果上报
 */
- (void)startReportCache;

@end


FOUNDATION_STATIC_INLINE NSString * statusDomainWithPayStatus(LQPayDelegateType status)
{
    switch (status) {
        case kLQPayDelegateTypeUnableToMakePayments:
            return @"不支持内购支付";
            break;
        case kLQPayDelegateTypeWillRequestProductInfo:
            return @"开始请求商品信息";
            break;
        case kLQPayDelegateTypeRequestProductInfoSuccess:
            return @"商品信息请求成功";
            break;
        case kLQPayDelegateTypeRequestProductInfoFailure:
            return @"商品信息请求失败";
            break;
        case kLQPayDelegateTypePayCanceled:
            return @"支付取消";
            break;
        case kLQPayDelegateTypePaySuccess:
            return @"支付成功";
            break;
        case kLQPayDelegateTypePayFailure:
            return @"开支付失败";
            break;
        case kLQPayDelegateTypeConfirmOrderSuccess:
            return @"订单确认成功";
            break;
        case kLQPayDelegateTypeConfirmOrderFailure:
            return @"订单确认失败";
            break;
        default:
            break;
    }
    return nil;
}

