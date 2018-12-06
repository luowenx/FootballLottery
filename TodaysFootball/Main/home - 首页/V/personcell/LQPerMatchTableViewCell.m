//
//  LQPerMatchTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPerMatchTableViewCell.h"

@implementation LQPerMatchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *header = [UIView newAutoLayoutView];
        header.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:header];
        [header autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [header autoSetDimension:ALDimensionHeight toSize:7];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.textColor = UIColorFromRGB(0xa7a7a7);
        _timeLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        
        UIView *lineTime = [UIView newAutoLayoutView];
        lineTime.backgroundColor =UIColorFromRGB(0xededed);
        [self.contentView addSubview:lineTime];
        [lineTime autoSetDimensionsToSize:CGSizeMake(0.5, 10)];
        [lineTime autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [lineTime autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeLabel withOffset:10];
        
        _beanView = [LQBeanView newAutoLayoutView];
        [self.contentView addSubview:_beanView];
        [_beanView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineTime withOffset:10];
        [_beanView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        
        _lookButton = [UIButton newAutoLayoutView];
        _lookButton.titleLabel.font = [UIFont lqsFontOfSize:20];
        [_lookButton setTitleColor:UIColorFromRGB(0xa2a2a2) forState:(UIControlStateNormal)];
        [_lookButton setTitle:@"查看" forState:(UIControlStateNormal)];
        [self.contentView addSubview:_lookButton];
        [_lookButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineTime withOffset:10];
        [_lookButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        
        _lookNumbersLabel = [UILabel newAutoLayoutView];
        _lookNumbersLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _lookNumbersLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_lookNumbersLabel];
        [_lookNumbersLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_lookNumbersLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _ingButton = [UIButton newAutoLayoutView];
        [_ingButton setTitle:@"进行中" forState:(UIControlStateNormal)];
        _ingButton.titleLabel.font = [UIFont lqsFontOfSize:20];
        [_ingButton setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_ingButton];
        [_ingButton autoSetDimensionsToSize:CGSizeMake(43, 15)];
        [_ingButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_ingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _hitImageView = [UIButton newAutoLayoutView];
        _hitImageView.titleLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        [_hitImageView setTitle:@"红" forState:(UIControlStateNormal)];
        [_hitImageView setBackgroundImage:imageWithName(@"红") forState:UIControlStateNormal];
        [_hitImageView setTitle:@"黑" forState:(UIControlStateSelected)];
        [_hitImageView setBackgroundImage:imageWithName(@"黑") forState:UIControlStateSelected];
        [self.contentView addSubview:_hitImageView];
        [_hitImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_timeLabel];
        [_hitImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_hitImageView autoSetDimensionsToSize:CGSizeMake(15, 15)];
        
        _hitTitleLabel  = [UILabel newAutoLayoutView];
        _hitTitleLabel.textColor = UIColorFromRGB(0xa7a7a7);
        _hitTitleLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_hitTitleLabel];
        [_hitTitleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_hitTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_hitImageView withOffset:-8];
        
        UILabel *VSLabel = [UILabel newAutoLayoutView];
        VSLabel.text = @"VS";
        VSLabel.textColor = UIColorFromRGB(0x7a7a7a);
        VSLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        VSLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:VSLabel];
        @weakify(VSLabel)
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired) forConstraints:^{
            [VSLabel_weak_ autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
            [VSLabel_weak_ autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        }];
        [VSLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [VSLabel autoSetDimension:ALDimensionHeight toSize:25];
        _VSLabel = VSLabel;
        
        UIView *matchLineLeft = [UIView newAutoLayoutView];
        matchLineLeft.backgroundColor = UIColorFromRGB(0xededed);
        [self.contentView addSubview:matchLineLeft];
        [matchLineLeft autoSetDimensionsToSize:CGSizeMake(1, 9)];
        [matchLineLeft autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [matchLineLeft autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineLeft.superview withOffset:-.25 * UIDeviceScreenWidth];
        
        UIView *matchLineRight = [UIView newAutoLayoutView];
        matchLineRight.backgroundColor = UIColorFromRGB(0xededed);
        [self.contentView addSubview:matchLineRight];
        [matchLineRight autoSetDimensionsToSize:CGSizeMake(1, 9)];
        [matchLineRight autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [matchLineRight autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineRight.superview withOffset: .25 * UIDeviceScreenWidth];
        
        _matchLabel = [UILabel newAutoLayoutView];
        _matchLabel.textAlignment = NSTextAlignmentCenter;
        _matchLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _matchLabel.font = [UIFont lqsFontOfSize:24];
        [self.contentView addSubview:_matchLabel];
        [_matchLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [_matchLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_matchLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineLeft];
        
        _ranksLeftLabel = [UILabel newAutoLayoutView];
        _ranksLeftLabel.font = [UIFont lqsFontOfSize:24];
        _ranksLeftLabel.textAlignment = NSTextAlignmentCenter;
        _ranksLeftLabel.textColor = UIColorFromRGB(0x7a7a7a);
        [self.contentView addSubview:_ranksLeftLabel];
        [_ranksLeftLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [_ranksLeftLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineLeft];
        [_ranksLeftLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:VSLabel];
        
        _ranksRightLabel = [UILabel newAutoLayoutView];
        _ranksRightLabel.font = [UIFont lqsFontOfSize:24];
        _ranksRightLabel.textAlignment = NSTextAlignmentCenter;
        _ranksRightLabel.textColor = UIColorFromRGB(0x7a7a7a);
        [self.contentView addSubview:_ranksRightLabel];
        [_ranksRightLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [_ranksRightLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:VSLabel];
        [_ranksRightLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineRight];
        
        _scoreLabel = [UILabel newAutoLayoutView];
        _scoreLabel.font = [UIFont lqsFontOfSize:24];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_scoreLabel];
        [_scoreLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:VSLabel];
        [_scoreLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineRight];
        [_scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.font = [UIFont lqsFontOfSize:32];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingSpecial + 7];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        
        [_VSLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:kLQSPaddingLarge];
    }
    return self;
}


+(CGFloat)staticHeight
{
    // 7 + kLQSPaddingSpecial + kLQSPaddingLarge + 25 + kLQSPaddingHuge + kLQSPaddingHuge +
    return 104 + [UIFont lqsFontOfSize:20].lineHeight;
}

@end
