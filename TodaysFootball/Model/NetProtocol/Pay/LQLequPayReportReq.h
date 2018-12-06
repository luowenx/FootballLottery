//
//  LQLequPayReportReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/25.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 订单校验
 */
@interface LQLequPayReportReq : LQHttpRequest

@property (nonatomic, copy) NSString * openId;

@end

@interface LQLequPayReportRes : LQNetResponse

@end
