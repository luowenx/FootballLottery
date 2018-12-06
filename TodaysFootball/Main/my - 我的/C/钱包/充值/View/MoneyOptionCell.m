//
//  MoneyOptionCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "MoneyOptionCell.h"

@implementation MoneyOptionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame ];
    if (self) {
        _priceLabel = [UILabel newAutoLayoutView];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont lqsFontOfSize:30 isBold:YES];
        _priceLabel.textColor = UIColorFromRGB(0x7a7a7a);
        [self.contentView addSubview:_priceLabel];
        [_priceLabel autoSetDimension:ALDimensionHeight toSize:25];
        [_priceLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        _numberLabel = [UILabel newAutoLayoutView];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont lqsFontOfSize:24];
        _numberLabel.textColor = [UIColor flsMainColor2];
        [self.contentView addSubview:_numberLabel];
        [_numberLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_numberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_priceLabel];
        
        _cornerView = [UIImageView newAutoLayoutView];
        _cornerView.image = imageWithName(@"recharge_discount_corner");
        [self.contentView addSubview:_cornerView];
        [_cornerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_cornerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.contentView borderWidth:.5 color:UIColorFromRGB(0xbfbfbf)];
        [self.contentView roundedRectWith:3];
        self.contentView.layer.masksToBounds = NO;
    }
    return self;
}

@end
