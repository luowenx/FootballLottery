//
//  LQExpenseListReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 我的钱包 -- 消费列表
 */
@interface LQExpenseListReq : LQHttpRequest

@end


@interface LQExpenseListRes : LQNetResponse

@property (nonatomic) NSInteger colorbean;

@property (nonatomic, strong) NSArray * expenseList;

@end
