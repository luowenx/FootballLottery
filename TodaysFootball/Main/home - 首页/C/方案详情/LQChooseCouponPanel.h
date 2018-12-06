//
//  LQChooseCouponPanel.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 优惠券选中面板
 */
@class LQAvailableCoupon;
@interface LQChooseCouponPanel : UIViewController
// 该方案能用的优惠券
@property (nonatomic, copy) NSArray<LQAvailableCoupon *> * couponList;
// 选中的优惠券
@property (nonatomic) NSInteger selectedIndex;
// 选中回调
@property (nonatomic, copy) void (^chooseCouoon)(LQAvailableCoupon *coupon);

@end
