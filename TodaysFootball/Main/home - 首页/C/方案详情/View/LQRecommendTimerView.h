//
//  LQRecommendTimerView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPlanDetailHeader.h"

/**
 *  方案推荐 计时器   2017-12-21 03:50:00
 *  高度固定 141 + 51(可购买时)
 */
@interface LQRecommendTimerView : UIView

@property (nonatomic) LQPlanDetailShowType showType;

/**
 刷新倒计时时间

 @param interval 多少多少秒
 */
-(void)updateTimeInterval:(NSTimeInterval)interval;

/**
 结束可购买
 */
-(void)endTheTimer;

@property (nonatomic, copy) void (^completeTimer)(void);

// 总高度
-(CGFloat)totalHeight;

@end
