//
//  LQMyOrderPlanObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertPlanObj.h"

/**
 我的订单对象
 */
@interface LQMyOrderPlanObj : LQExpertPlanObj

//// 命中
//@property (nonatomic, copy) NSString * hitRateValue;
// 彩豆数量
@property (nonatomic) NSInteger amount;
// 购买时间
@property (nonatomic) long long  purchasedTime;

@end
