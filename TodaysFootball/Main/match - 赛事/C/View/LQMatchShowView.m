//
//  LQMatchShowView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchShowView.h"

@implementation LQMatchShowView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _VSLabel = [UILabel newAutoLayoutView];
        _VSLabel.font = [UIFont lqsBEBASFontOfSize:30];
        _VSLabel.text = @"VS";
        _VSLabel.textColor = UIColorFromRGB(0x404040);
        [self addSubview:_VSLabel];
        [_VSLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_VSLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        @weakify(self)
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired) forConstraints:^{
            [self_weak_.VSLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
            [self_weak_.VSLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        }];
        
        _homeIconView = [[LQAvatarView alloc] initWithLength:25 grade:(kLQAvatarViewGradeMini)];
        [self addSubview:_homeIconView];
        [_homeIconView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_homeIconView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_VSLabel withOffset:-25];
        
        _homeNameLabel = [UILabel newAutoLayoutView];
        _homeNameLabel.font = [UIFont lqsFontOfSize:28];
        _homeNameLabel.textColor = UIColorFromRGB(0x393939);
        [self addSubview:_homeNameLabel];
        [_homeNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_homeNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_homeIconView withOffset:-14];
        [_homeNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _guestIconView = [[LQAvatarView alloc] initWithLength:25 grade:(kLQAvatarViewGradeMini)];
        [self addSubview:_guestIconView];
        [_guestIconView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_guestIconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_VSLabel withOffset:25];
        
        _guestNameLabel = [UILabel newAutoLayoutView];
        _guestNameLabel.font = [UIFont lqsFontOfSize:28];
        _guestNameLabel.textColor = UIColorFromRGB(0x393939);
        [self addSubview:_guestNameLabel];
        [_guestNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_guestNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_guestIconView withOffset:14];
        [_guestNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        [_guestIconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        [_guestIconView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
    }
    return self;
}

@end
