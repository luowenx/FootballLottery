//
//  LQOptionManager.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 各个操作
 */
@interface LQOptionManager : NSObject

/**
 赛事关注

 @param isFollowed 目前是否是关注
 @param matchInfoId 赛事id
 @param callBack 回调
 */
+(void)followMatchCurrentisFollowed:(BOOL)isFollowed
                        matchInfoId:(NSString *)matchInfoId
                           callBack:(void(^)(BOOL success, NSError *error))callBack;

/**
 专家关注

 @param isFollowed 目前是否是关注
 @param expertUserId 专家userid
 @param callBack 回调
 */
+(void)followExpertCurrentisFollowed:(BOOL)isFollowed
                        expertUserId:(NSString *)expertUserId
                            callBack:(void(^)(BOOL success, NSError *error))callBack;

/**
 方案收藏

 @param isFavorite 当前是否是收藏
 @param threadId 方案id
 @param callBack 回调
 */
+(void)planisFavorite:(BOOL)isFavorite
             threadId:(NSString *)threadId
             callBack:(void(^)(BOOL success, NSError *error))callBack;


/**
 资讯收藏

 @param isFavorite 当前是否收藏
 @param docId 资讯id
 @param callBack 回调
 */
+ (void)infomationisFavorite:(BOOL)isFavorite
                       docId:(NSString *)docId
                    callBack:(void(^)(BOOL success, NSError *error))callBack;

/**
 购买方案

 @param threadId 方案id
 @param couponId 优惠券id
 @param price 价格
 @param callBack 回调
 */
+(void)payPlanThreadId:(NSString *)threadId
              couponId:(NSString *)couponId
                 price:(NSString *)price
              callBack:(void(^)(BOOL success, NSError *error))callBack;


/**
 从某个页面呼起登录页
 
 @param viewCtrl 呼起的控制器
 */
+(void)loginMainInTarge:(UIViewController *)viewCtrl;


/**
 订单校验
 */
+ (void)checkOrder;

@end
