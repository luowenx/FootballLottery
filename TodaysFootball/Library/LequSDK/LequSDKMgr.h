//
//  LequSDKMgr.h
//  LequSDKMgr
//
//  Created by 莫 东荣 on 13-4-9.
//  Copyright (c) 2013年 莫 东荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKit/StoreKit.h"

@interface LequSDKMgr : NSObject
{
    NSString* appId_;
    NSString* appKey_;
   
    NSString* inviterCode_;
//    NSString* openId;
//    NSString* loginKey;
}

+ (LequSDKMgr *)getInstance;
- (NSString *)getOpenId;
- (void)initSDK;
- (void)initSDK:(NSString *)weixinId;

#pragma regist
- (void)openRegist:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller;
- (void)openRegist:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *) inviterCode;
- (void)openRegist:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *) inviterCode : (NSString *)userName : (NSString *)passWord;
- (void)openRegist:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *)userName : (NSString *)passWord;

#pragma login
- (void)openLogin:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller;
- (void)openLogin:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *) inviterCode;
- (void)openLogin:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *) inviterCode : (NSString *)userName : (NSString *)passWord;
- (void)openLogin:(NSString *)appId : (NSString *)appKey : (UIViewController *)controller : (NSString *)userName : (NSString *)passWord;

#pragma style
- (void)setStyleName:(NSString*)styleName;

#pragma center
- (void)openCenter: (UIViewController *)controller;

#pragma pay
- (void)openPay: (NSString *)serverId : (NSString *)nickName : (NSString *)callBack : (UIViewController *)controller;
- (void)openPay: (NSString *)serverId : (NSString *)nickName : (NSNumber *)payAmount : (NSString *)callBack : (UIViewController *)controller;

#pragma share
- (void)openShare: (UIViewController *)controller;

#pragma log
- (void)log: (NSString*)log_key : (NSInteger)log_data: (NSString*)log_remark;

- (void)checkAilpay: (NSURL *)url : (UIViewController *)controller;

- (void)applePayCallBack:(NSString *)url :(SKPaymentTransaction *)transaction :(NSString *)resultStr;



@end
