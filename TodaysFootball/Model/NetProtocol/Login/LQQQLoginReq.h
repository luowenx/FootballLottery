//
//  LQQQLoginReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"
#import "LQLoginRes.h"

/**
 qq登录  api
 */
@interface LQQQLoginReq : LQHttpRequest
//
@property (nonatomic, copy) NSString * openid;

// 用于打通腾讯sdk、唯一id
@property (nonatomic, copy) NSString * unionid;

// 昵称
@property (nonatomic, copy) NSString * nickname;
//头像地址
@property (nonatomic, copy) NSString * avatar;
// 性别 1 男/2 女
@property (nonatomic, copy) NSString * gender;


@end



