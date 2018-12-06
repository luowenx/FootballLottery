//
//  LQTradeReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 确认订单
 */
@interface LQTradeReq : LQHttpRequest

@end

@interface LQTradeRes : LQNetResponse

@property (nonatomic, copy) NSString * iapOrderId;

@end
