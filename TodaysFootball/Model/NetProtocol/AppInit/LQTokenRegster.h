//
//  LQTokenRegster.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 过期 token 刷新
 */
@interface LQTokenRegsterReq : LQHttpRequest
/**
 10位的时间戳
 */
@property (nonatomic) long long t;
/**
 appKey ： lwapp01
 */
@property (nonatomic, copy) NSString * a;
/**
 strtolower(md5(a+t))全部小写的
 appKey+timestamp 的 md5 值。
 */
@property (nonatomic, copy) NSString * s;
/**
 init 接口获取的 rk
 */
@property (nonatomic, copy) NSString * rk;

@end

@interface LQTokenRegsterRes : LQNetResponse

@property (nonatomic, copy) NSString * tk;

@property (nonatomic, copy) NSString * rk;

@end

