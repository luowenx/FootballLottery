//
//  LQOptionManager.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQOptionManager.h"
#import "LQLoginMainViewCtrl.h"

#import "LQPlanFavoritesReq.h"
#import "LQDePlanFavoritesReq.h"
#import "LQFollowMatchReq.h"
#import "LQDeleteMatchReq.h"
#import "LQFollowExpert.h"
#import "LQDeleteExpert.h"
#import "LQPayPlanReq.h"
#import "LQDeleteFavoriteInfoReq.h"
#import "LQFavoriteInfoReq.h"
#import "LQLequPayReportReq.h"

@implementation LQOptionManager

+(void)followMatchCurrentisFollowed:(BOOL)isFollowed
                        matchInfoId:(NSString *)matchInfoId
                           callBack:(void(^)(BOOL success, NSError *error))callBack
{
    if (isFollowed) {
        LQDeleteMatchReq *req = [[LQDeleteMatchReq alloc] init];
        [req apendRelativeUrlWith:matchInfoId];
        [req requestWithCompletion:^(id response) {
            LQNetResponse *res = (LQNetResponse *)response;
            if (res.ret == 0) {
                callBack?callBack(YES, nil):nil;
                userManager.followMatchNum = 0;
            }else {
//                callBack?callBack(NO, nil):nil;
            }
        } error:^(NSError *error) {
            callBack?callBack(NO, error):nil;
        }];
        return;
    }

    LQFollowMatchReq *req = [[LQFollowMatchReq alloc] init];
    req.matchInfoId = matchInfoId;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            callBack?callBack(YES, nil):nil;
            userManager.followMatchNum = 0;
        }else {
//            callBack?callBack(NO, nil):nil;
        }
    } error:^(NSError *error) {
        callBack?callBack(NO, error):nil;
    }];
}


+(void)followExpertCurrentisFollowed:(BOOL)isFollowed
                        expertUserId:(NSString *)expertUserId
                            callBack:(void(^)(BOOL success, NSError *error))callBack
{
    if (isFollowed) {
        LQDeleteExpert *req = [[LQDeleteExpert alloc] init];
        [req apendRelativeUrlWith:expertUserId];
        [req requestWithCompletion:^(id response) {
            LQNetResponse *res = (LQNetResponse *)response;
            if (res.ret == 0) {
                callBack?callBack(YES, nil):nil;
                userManager.followExpertNum = 0;
                NSDictionary *userInfo = @{kLQExpertIDKey:expertUserId, kLQExpertFollowedKey:@(!isFollowed)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kLQFollowExpertNotification object:nil userInfo:userInfo];
            }else {
//                callBack?callBack(NO, nil):nil;
            }
        } error:^(NSError *error) {
            callBack?callBack(NO, error):nil;
        }];
        return;
    }
    LQFollowExpert *req = [[LQFollowExpert alloc] init];
    req.expertUserId = expertUserId;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            callBack?callBack(YES, nil):nil;
            userManager.followExpertNum = 0;
            NSDictionary *userInfo = @{kLQExpertIDKey:expertUserId, kLQExpertFollowedKey:@(!isFollowed)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kLQFollowExpertNotification object:nil userInfo:userInfo];
        }else {
//            callBack?callBack(NO, nil):nil;
        }
    } error:^(NSError *error) {
        callBack?callBack(NO, error):nil;
    }];
}


+(void)planisFavorite:(BOOL)isFavorite
             threadId:(NSString *)threadId
             callBack:(void(^)(BOOL success, NSError *error))callBack
{
    if (isFavorite) {
        LQDePlanFavoritesReq *req = [[LQDePlanFavoritesReq alloc] init];
        [req apendRelativeUrlWith:threadId];
        [req requestWithCompletion:^(id response) {
            LQNetResponse *res = (LQNetResponse *)response;
            if (res.ret == 0) {
                callBack?callBack(YES, nil):nil;
            }else {
//                callBack?callBack(NO, nil):nil;
            }
        } error:^(NSError *error) {
            callBack?callBack(NO, error):nil;
        }];
        return;
    }
    
    LQPlanFavoritesReq *req = [[LQPlanFavoritesReq alloc] init];
    req.threadId = threadId;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            callBack?callBack(YES, nil):nil;
        }else {
//            callBack?callBack(NO, nil):nil;
        }
    } error:^(NSError *error) {
        callBack?callBack(NO, error):nil;
    }];
}

+ (void)infomationisFavorite:(BOOL)isFavorite
                       docId:(NSString *)docId
                    callBack:(void(^)(BOOL success, NSError *error))callBack
{
    if (isFavorite) {
        LQDeleteFavoriteInfoReq *req = [[LQDeleteFavoriteInfoReq alloc] init];
        req.docId = docId;
        [req requestWithCompletion:^(id response) {
            LQNetResponse *res = (LQNetResponse *)response;
            if (res.ret == 0) {
                callBack?callBack(YES, nil):nil;
                
            }
        } error:^(id error) {
            callBack?callBack(NO, error):nil;
        }];return;
    }
    
    LQFavoriteInfoReq *req = [[LQFavoriteInfoReq alloc] init];
    req.docId = docId;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            callBack?callBack(YES, nil):nil;
            
        }
    } error:^(id error) {
        callBack?callBack(NO, error):nil;
    }];
}


+(void)payPlanThreadId:(NSString *)threadId
              couponId:(NSString *)couponId
                 price:(NSString *)price
              callBack:(void (^)(BOOL, NSError *))callBack
{
    LQPayPlanReq *req = [[LQPayPlanReq alloc] init];
    req.threadId = threadId;
    req.couponId = couponId;
    req.price = price;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == kLQNetResponseSuccess) {
            LQUserInfo *user = [[LQUserInfo alloc] initWith:res.data];
            userManager.currentUser = user;
            [userManager saveCurrentUser];
            callBack?callBack(YES, nil):nil;
            NSDictionary *userInfo = @{kLQPlanIDKey:threadId};
            [[NSNotificationCenter defaultCenter] postNotificationName:kLQPayPlanNotification object:nil userInfo:userInfo];
        }else {
            callBack?callBack(NO, nil):nil;
        }
    } error:^(NSError *error) {
        callBack?callBack(NO, error):nil;
    }];
}

+(void)loginMainInTarge:(UIViewController *)viewCtrl
{
    LQLoginMainViewCtrl *logViewCtrl = [[LQLoginMainViewCtrl alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewCtrl];
    [viewCtrl presentViewController:nav animated:YES completion:^{}];
}

+ (void)checkOrder
{
    NSString *openid = stringNotNil([LQUserDefault readObjectForKey:@"open_id" defaultObject:@""]);
    
    if (openid.length <= 0) {
        return;
    }
    
    LQLequPayReportReq *req = [[LQLequPayReportReq alloc] init];
    req.openId = openid;

    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse*)response;
        if (res.ret == kLQNetResponseSuccess) {
            LQUserInfo *user = [[LQUserInfo alloc] initWith:res.data];
            userManager.currentUser = user;
            [userManager saveCurrentUser];
            [LQJargon hiddenJargon:@"充值到账"];
        }
        
    } error:^(id error) {
        [LQJargon hiddenJargon:@"充值失败"];
    }];
}

@end
