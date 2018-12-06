//
//  LQAppInitReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 开机接口
 */
@interface LQAppInitReq : LQHttpRequest

/**
 时间戳
 */
@property (nonatomic) long long   t;

/**
 appKey : lwapp01
 */
@property (nonatomic, copy) NSString *a;

/**
 strtolower(md5(a+t))全部小写的 appKey+timestamp 的 md5 值
 */
@property (nonatomic, copy) NSString *s;

@end

@interface LQAppInitRes : LQNetResponse

@property (nonatomic, copy) NSString *tk;

@property (nonatomic, copy) NSString *rk;

@end
