//
//  LQApplepay.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQPayProtocol.h"

/**
 苹果支付
 */
@protocol LQPayProtocol;
@interface LQApplepay : NSObject<LQPayProtocol>

+ (instancetype)defaultPay;

@end
