//
//  LQCouponCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 优惠券cell
 */
@interface LQCouponCell : UITableViewCell
// 背景图片
@property (nonatomic, strong) UIImageView * bgView;

@property (nonatomic, strong) UILabel * beanNumLabel;

@property (nonatomic, strong) UILabel * conditionPriceTips;
@property (nonatomic, strong) UILabel * conditionRoleTips;
@property (nonatomic, strong) UILabel * conditionDateTips;
@property (nonatomic, strong) UILabel * bottomTips;

@end
