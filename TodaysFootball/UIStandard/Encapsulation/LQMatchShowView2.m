//
//  LQMatchShowView2.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchShowView2.h"

@implementation LQMatchShowView2

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *matchView = [UIView newAutoLayoutView];
        matchView.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [self addSubview:matchView];
        [matchView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [matchView autoSetDimension:ALDimensionHeight toSize:25];
        [matchView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [matchView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [matchView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        _bgView = matchView;
        
        UILabel *VSLabel = [UILabel newAutoLayoutView];
        VSLabel.text = @"VS";
        VSLabel.textColor = UIColorFromRGB(0x7a7a7a);
        VSLabel.font = [UIFont lqsBEBASFontOfSize:24];
        [matchView addSubview:VSLabel];
        [VSLabel autoCenterInSuperview];
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired) forConstraints:^{
            [VSLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
            [VSLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        }];
        _VSLabel = VSLabel;
        
        UIView *matchLineLeft = [UIView newAutoLayoutView];
        matchLineLeft.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [matchView addSubview:matchLineLeft];
        [matchLineLeft autoSetDimensionsToSize:CGSizeMake(.5, 18)];
        [matchLineLeft autoAlignAxisToSuperviewAxis:(ALAxisHorizontal)];
        [matchLineLeft autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineLeft.superview withOffset:-.25 * UIDeviceScreenWidth];
        
        UIView *matchLineRight = [UIView newAutoLayoutView];
        matchLineRight.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [matchView addSubview:matchLineRight];
        [matchLineRight autoSetDimensionsToSize:CGSizeMake(.5, 18)];
        [matchLineRight autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [matchLineRight autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineRight.superview withOffset: .25 * UIDeviceScreenWidth];
        
        _matchLabel = [UILabel newAutoLayoutView];
        _matchLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _matchLabel.font = [UIFont lqsFontOfSize:24];
        _matchLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_matchLabel];
        [_matchLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_matchLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_matchLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineLeft];
        
        _ranksLeftLabel = [UILabel newAutoLayoutView];
        _ranksLeftLabel.textColor =UIColorFromRGB(0x7a7a7a);
        _ranksLeftLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        _ranksLeftLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_ranksLeftLabel];
        [_ranksLeftLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_ranksLeftLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineLeft];
        [_ranksLeftLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:VSLabel];
        
        _ranksRightLabel = [UILabel newAutoLayoutView];
        _ranksRightLabel.textColor =UIColorFromRGB(0x7a7a7a);
        _ranksRightLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        _ranksRightLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_ranksRightLabel];
        [_ranksRightLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_ranksRightLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:VSLabel];
        [_ranksRightLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineRight];
        
        UIImageView *id_imageView = [UIImageView newAutoLayoutView];
        id_imageView.image  = imageWithName(@"更多");
        [matchView addSubview:id_imageView];
        [id_imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [id_imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [id_imageView autoSetDimensionsToSize:CGSizeMake(5, 10)];
        _cornerView = id_imageView;
        
        _scoreLabel = [UILabel newAutoLayoutView];
        _scoreLabel.textColor =UIColorFromRGB(0xa2a2a2);
        _scoreLabel.font = [UIFont lqsFontOfSize:24];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_scoreLabel];
        [_scoreLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_scoreLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineRight];
        [_scoreLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:id_imageView];
        
    }
    return self;
}

@end
