//
//  LQGetVerifyCodeReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 获取验证码
 */
@interface LQGetVerifyCodeReq : LQHttpRequest

@property (nonatomic, copy) NSString *mobile;


@end
