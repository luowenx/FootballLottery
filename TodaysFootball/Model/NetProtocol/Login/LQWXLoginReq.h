//
//  LQWXLoginReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"
#import "LQLoginRes.h"

/**
 微信登录api
 */
@interface LQWXLoginReq : LQHttpRequest

@property (nonatomic, copy) NSString * openid;
// 用于打通腾讯sdk、唯一id
@property (nonatomic, copy) NSString * unionid;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * gender;

@end
