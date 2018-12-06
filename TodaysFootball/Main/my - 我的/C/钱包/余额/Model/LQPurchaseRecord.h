//
//  LQPurchaseRecord.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/15.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 消费记录
 */
@interface LQPurchaseRecord : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic) NSInteger amount;

@property (nonatomic) long long expenseTime;

@property (nonatomic) LQPurchaseRecordType type;

@property (nonatomic, copy) NSString *remark;

@end

/*
[0]    (null)    @"amount" : (long)30
[1]    (null)    @"expenseTime" : @"2017-12-28 11:07:22"
[2]    (null)    @"type" : (long)1
[3]    (null)    @"remark" : @"充值"
*/
