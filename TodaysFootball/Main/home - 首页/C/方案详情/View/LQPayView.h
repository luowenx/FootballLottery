//
//  LQPayView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPlanDetailHeader.h"

/**
 *  底部支付按钮
 *  无需设置高度  （51 + kLQSafeBottomHeight）
 */
@class LQAvailableCoupon;
@interface LQPayView : UIView
@property (nonatomic) LQPlanDetailShowType showType;

/**
 设置价格

 @param colorbean 价格
 @param coupon 优惠
 */
- (void)setColorbean:(NSInteger)colorbean discount:(LQAvailableCoupon*)coupon;

/**
 支付
 */
@property (nonatomic, copy) void (^pay)(void);

/**
 优惠卷
 */
@property (nonatomic, copy) void (^chooseDiscount)(void);

@end
