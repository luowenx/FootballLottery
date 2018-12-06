//
//  LQMyOtherTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyOtherTableViewCell.h"

@implementation LQMyOtherTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _iconView  = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconView];
        [_iconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_iconView autoSetDimensionsToSize:CGSizeMake(16, 16)];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.font = [UIFont lqsFontOfSize:30];
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconView withOffset:12];
        
        UIImageView *arrowView = [UIImageView newAutoLayoutView];
        arrowView.image = imageWithName(@"更多");
        [self.contentView addSubview:arrowView];
        [arrowView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [arrowView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
        [arrowView autoSetDimensionsToSize:CGSizeMake(6, 14)];
        
        UIView *topLine = [UIView newAutoLayoutView];
        topLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:topLine];
        [topLine autoSetDimension:ALDimensionHeight toSize:.5];
        [topLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [topLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
        _topLine = topLine;
    }
    return self;
}

@end
