//
//  LQPayReportReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 上报支付结果
 */
@interface LQPayReportReq : LQHttpRequest

@property (nonatomic, copy) NSString * iapOrderId;

@property (nonatomic, copy) NSString * data;

@end
