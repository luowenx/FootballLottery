//
//  LQCouponCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCouponCell.h"

@implementation LQCouponCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.bgView = [UIImageView newAutoLayoutView];
        self.bgView.image = imageWithName(@"mine_优惠券_bg");
        [self.contentView addSubview:self.bgView];
        [self.bgView autoCenterInSuperview];
        [self.bgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17.5];
        [self.bgView autoSetDimension:ALDimensionHeight toSize:92];
        
        _beanNumLabel = [UILabel newAutoLayoutView];
        _beanNumLabel.textColor = [UIColor flsMainColor];
        _beanNumLabel.font = [UIFont lqsBEBASFontOfSize:54];
        [self.bgView addSubview:_beanNumLabel];
        [_beanNumLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:27];
        [_beanNumLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        
        UILabel *beanTips = [UILabel newAutoLayoutView];
        beanTips.textColor = [UIColor flsMainColor];
        beanTips.font = [UIFont lqsFontOfSize:24];
        beanTips.text = @"乐豆";
        [self.bgView addSubview:beanTips];
        [beanTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_beanNumLabel withOffset:5];
        [beanTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_beanNumLabel];
        RAC(beanTips,textColor) = RACObserve(_beanNumLabel, textColor);
        
        _conditionPriceTips = [UILabel newAutoLayoutView];
        _conditionPriceTips.textColor = UIColorFromRGB(0xa2a2a2);
        _conditionPriceTips.font = [UIFont lqsFontOfSize:24];
        [self.bgView addSubview:_conditionPriceTips];
        [_conditionPriceTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_beanNumLabel];
        [_conditionPriceTips autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_beanNumLabel withOffset:5];
        
        _conditionRoleTips = [UILabel newAutoLayoutView];
        _conditionRoleTips.textColor = UIColorFromRGB(0x404040);
        _conditionRoleTips.font = [UIFont lqsFontOfSize:24];
        [self.bgView addSubview:_conditionRoleTips];
        [_conditionRoleTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:beanTips];
        [_conditionRoleTips autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        _conditionDateTips = [UILabel newAutoLayoutView];
        _conditionDateTips.font = [UIFont lqsFontOfSize:24];
        _conditionDateTips.textColor = UIColorFromRGB(0xa2a2a2);
        [self.bgView  addSubview:_conditionDateTips];
        [_conditionDateTips autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_conditionPriceTips];
        [_conditionDateTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_conditionRoleTips];
        
        _bottomTips = [UILabel newAutoLayoutView];
        _bottomTips.font = [UIFont lqsFontOfSize:22];
        _bottomTips.textColor =UIColorFromRGB(0xa2a2a2);
        [self.bgView addSubview:_bottomTips];
        [_bottomTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:27];
        [_bottomTips autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        
    }
    return self;
}


@end
