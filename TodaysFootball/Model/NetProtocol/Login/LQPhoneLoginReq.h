//
//  LQPhoneLoginReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"
#import "LQLoginRes.h"

/**
 电话号码登录api
 */
@interface LQPhoneLoginReq : LQHttpRequest
/* 电话号码 */
@property (nonatomic, copy) NSString * mobile;

/* 密码 */
@property (nonatomic, copy) NSString * pwd;

@end


