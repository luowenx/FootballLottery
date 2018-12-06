//
//  LQPayPlanReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 购买方案
 */
@interface LQPayPlanReq : LQHttpRequest

@property (nonatomic, copy) NSString * threadId;

@property (nonatomic, copy) NSString * couponId;

@property (nonatomic, copy) NSString * price;

@end
