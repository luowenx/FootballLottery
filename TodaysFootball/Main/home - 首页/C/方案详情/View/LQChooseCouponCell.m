//
//  LQChooseCouponCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQChooseCouponCell.h"

@implementation LQChooseCouponCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *bgView = [UIImageView newAutoLayoutView];
        bgView.image = imageWithName(@"planDetail_优惠券");
        [self.contentView addSubview:bgView];
        [bgView autoSetDimension:ALDimensionHeight toSize:60];
        [bgView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [bgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [bgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [bgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _beanNumLabel = [UILabel newAutoLayoutView];
        _beanNumLabel.font = [UIFont lqsFontOfSize:42];
        _beanNumLabel.textColor = [UIColor flsMainColor];
        [bgView addSubview:_beanNumLabel];
        [_beanNumLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [_beanNumLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
        
        UILabel *beanTips = [UILabel newAutoLayoutView];
        beanTips.text = @"乐豆";
        beanTips.textColor = UIColorFromRGB(0x626262);
        beanTips.font = [UIFont lqsFontOfSize:22];
        [bgView addSubview:beanTips];
        [beanTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_beanNumLabel];
        [beanTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_beanNumLabel withOffset:2];
        _beanTips = beanTips;

        _conditionPriceTips = [UILabel newAutoLayoutView];
        _conditionPriceTips.textColor = UIColorFromRGB(0xbcbcbc);
        _conditionPriceTips.font = [UIFont lqsFontOfSize:18];
        [bgView addSubview:_conditionPriceTips];
        [_conditionPriceTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_beanNumLabel];
        [_conditionPriceTips autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_beanNumLabel withOffset:3];
        
        _conditionRoleTips = [UILabel newAutoLayoutView];
        _conditionRoleTips.textColor = UIColorFromRGB(0x626262);
        _conditionRoleTips.font = [UIFont lqsFontOfSize:22];
        [bgView addSubview:_conditionRoleTips];
        [_conditionRoleTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:beanTips];
        [_conditionRoleTips autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        _conditionDateTips = [UILabel newAutoLayoutView];
        _conditionDateTips.textColor = UIColorFromRGB(0xbcbcbc);
        _conditionDateTips.font = [UIFont lqsFontOfSize:18];
        [bgView addSubview:_conditionDateTips];
        [_conditionDateTips autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_conditionRoleTips];
        [_conditionDateTips autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_conditionPriceTips];
        
        _noUserLabel = [UILabel newAutoLayoutView];
        _noUserLabel.textAlignment = NSTextAlignmentCenter;
        _noUserLabel.hidden = YES;
        _noUserLabel.text = @"不使用优惠券";
        _noUserLabel.font = [UIFont lqsFontOfSize:22];
        _noUserLabel.textColor = UIColorFromRGB(0x626262);
        _noUserLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_noUserLabel];
        [_noUserLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 3, 8, 3)];
     
        _selectedImageView = [UIImageView newAutoLayoutView];
        _selectedImageView.image = imageWithName(@"红圈对勾");
        [bgView addSubview:_selectedImageView];
        [_selectedImageView autoSetDimensionsToSize:CGSizeMake(19, 19)];
        [_selectedImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_selectedImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:21];
        
    }
    return self;
}



@end
