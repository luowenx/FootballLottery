//
//  LQLoginManager.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/3.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQLoginManager.h"

#import <UMShare/UMShare.h>
#import "LQQQLoginReq.h"
#import "LQWXLoginReq.h"
#import "LQPhoneLoginReq.h"
#import "LQOptionManager.h"

@interface LQLoginManager ()

@property (nonatomic, copy) void(^callBack)(BOOL success, NSError *error);

@property (nonatomic) BOOL isInstall;

@end

static  LQLoginManager * login = nil;
@implementation LQLoginManager

+ (instancetype)loginManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[LQLoginManager alloc] init];
    });
    return login;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isInstall = NO;
        @weakify(self)
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            if (self_weak_.isInstall) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSError *error = [[NSError alloc] initWithDomain:@"进入前台"
                                                                code:kLQLoginErrorCodeInstallEnterEnterForeground
                                                            userInfo:nil];
                    self_weak_.callBack?self_weak_.callBack(NO, error):nil;
                    self_weak_.isInstall = NO;
                });
            }
        }];
    }
    return self;
}

-(void)loginWithType:(LQLoginWayType)ty aParameters:(NSDictionary *)aParameters callBack:(void(^)(BOOL success, NSError *error))callBack
{
    self.callBack =  callBack;
    
    BAResponseSuccessBlock resultHander = ^(id response){
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == kLQNetResponseSuccess) {
            LQUserInfo *user = [[LQUserInfo alloc] initWith:res.data];
            userManager.currentUser = user;
            [userManager saveCurrentUser];
            
//            // 登录成功后，支付上报
            [LQOptionManager checkOrder];
            
            self.callBack?self.callBack(YES, nil):nil;
        }else{
            self.callBack?self.callBack(NO, nil):nil;
        }
        self.isInstall = NO;
    };
    
    if (ty == kLQLoginWayTypePhone) {
        LQPhoneLoginReq *req = [[LQPhoneLoginReq alloc] init];
        req.mobile = aParameters[@"phone"];
        req.pwd = aParameters[@"password"];
        [req requestWithCompletion:resultHander error:^(NSError *error) {
            self.callBack?self.callBack(NO, error):nil;
        }];
        return;
    }
    
    UMSocialPlatformType type = UMSocialPlatformType_Predefine_Begin;
    if (ty == kLQLoginWayTypeWX) {
        type = UMSocialPlatformType_WechatSession;
        self.isInstall = [[UMSocialManager defaultManager] isInstall:type];
        //        if (![[UMSocialManager defaultManager] isInstall:type]) {
        //            NSError *err = [[NSError alloc] initWithDomain:@"未安装微信客户端"
        //                                                      code:kLQLoginErrorCodeNoInstallWX
        //                                                  userInfo:nil];
        //            callBack?callBack(NO, err):nil;
        //        }
    }
    if (ty == kLQLoginWayTypeQQ) {
        type = UMSocialPlatformType_QQ;
        self.isInstall = [[UMSocialManager defaultManager] isInstall:type];
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            self.callBack?self.callBack(NO, error):nil;
            self.isInstall = NO;
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            LQWXLoginReq *req = (LQWXLoginReq *)[self reqWithTy:ty];
            req.openid = resp.openid;
            if (type == UMSocialPlatformType_WechatSession) {
                req.unionid = resp.uid;
            }
            if (type ==UMSocialPlatformType_QQ ) {
                req.unionid = resp.unionId;
            }
            req.nickname = resp.name;
            req.avatar = resp.iconurl;
            req.gender = [resp.unionGender isEqualToString:@"男"]?@"1":@"2";
            
            [req requestWithCompletion:resultHander error:^(NSError *error) {
                self.callBack?self.callBack(NO, error):nil;
                self.isInstall = NO;
                NSLog(@"登录失败");
            }];
        }
    }];
}

-(LQHttpRequest *)reqWithTy:(LQLoginWayType)ty
{
    switch (ty) {
        case kLQLoginWayTypeWX:
            return [[LQWXLoginReq alloc] init];
            break;
        case kLQLoginWayTypeQQ:
            return [[LQQQLoginReq alloc] init];
            break;
            
        default:
            break;
    }
    return nil;
}

@end
