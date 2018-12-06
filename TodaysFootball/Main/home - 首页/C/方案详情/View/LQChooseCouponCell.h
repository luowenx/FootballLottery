//
//  LQChooseCouponCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择优惠券 cell
 */
@interface LQChooseCouponCell : UITableViewCell

@property (nonatomic, strong) UILabel * beanNumLabel;
@property (nonatomic, strong) UILabel *beanTips;

@property (nonatomic, strong) UILabel * conditionPriceTips;
@property (nonatomic, strong) UILabel * conditionRoleTips;
@property (nonatomic, strong) UILabel * conditionDateTips;

//  hidden 默认等于YES, hidden = NO 会遮盖上面所以视图
@property (nonatomic, strong) UILabel * noUserLabel;
@property (nonatomic, strong) UIImageView * selectedImageView;

@end
