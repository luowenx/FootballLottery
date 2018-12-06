//
//  LQUserManager.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQUserInfo.h"

#define userManager [LQUserManager defaultManager]

typedef NS_ENUM(NSInteger, LQLoginWayType) {
    kLQLoginWayTypeWX,  // 微信登录
    kLQLoginWayTypeQQ,  // qq登录
    kLQLoginWayTypePhone,  // 手机号登陆
};

/**
 用户信息管理
 */
@interface LQUserManager : NSObject
+ (instancetype)defaultManager;

/* 当前用户信息、将会被保存 */
@property (nonatomic, strong) LQUserInfo * currentUser;

/* 授权token、本地保存 */
@property (nonatomic, copy) NSString *authorizeToken;

/*  token 过期后刷新 token 时使用的参数, 需要保存 */
@property (nonatomic, copy) NSString * restrictToken;

/**
 被点赞的评论 id 字典, 会被保存
 */
@property (nonatomic, strong) NSMutableDictionary *praiseDic;

/* 不会被保存 */
@property (nonatomic, readonly) BOOL isLogin;

/**
 *  以下数量不保存，只用于监听关注数据刷新，并不是准确的数值
 *   followExpertNum 专家关注数
 *   followExpertNum  赛事关注数
 */
@property (nonatomic) NSInteger followExpertNum;
@property (nonatomic) NSInteger followMatchNum;

/* 保存当前用户信息 */
- (BOOL)saveCurrentUser;

/* 退出当前用户 */
- (void)logOut;


/***  * 外部逻辑 *  ***/
-(void)getUsers;

@end

@class LQComment;
@interface LQUserManager (Praise)

- (void)praiseComm:(LQComment *)comm;

- (BOOL)containsComm:(LQComment *)comm;

@end


