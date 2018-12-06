//
//  LQInfomationCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInfomationCell.h"

@implementation LQInfomationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _coverImageView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_coverImageView];
        [_coverImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingLarge];
        [_coverImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_coverImageView autoSetDimensionsToSize:CGSizeMake(110, 70)];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        _titleLabel.font = [UIFont lqsFontOfSize:32];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingLarge];
        [_titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_coverImageView];
        [_titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_coverImageView withOffset:-kLQSPaddingHuge];
        
        _subTitleLabel = [UILabel newAutoLayoutView];
        _subTitleLabel.font = [UIFont lqsFontOfSize:20];
        _subTitleLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_coverImageView];
        [_subTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLabel];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.9];
    }
    return self;
}

+ (CGFloat)selfHeight
{
    return 105;
}

@end
