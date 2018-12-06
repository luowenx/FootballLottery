//
//  LQBindingReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 绑定手机号
 */
@interface LQBindingReq : LQHttpRequest

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *verifycode;

@end
