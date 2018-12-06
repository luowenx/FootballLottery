//
//  LQBeanView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/18.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBeanView.h"

@implementation LQBeanView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _beanLabel = [UILabel newAutoLayoutView];
        _beanLabel.font = [UIFont lqsFontOfSize:20];
        _beanLabel.textColor = [UIColor flsMainColor];
        [self addSubview:_beanLabel];
        [_beanLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_beanLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_beanLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _beanImageView = [UIImageView newAutoLayoutView];
        _beanImageView.image = imageWithName(@"彩豆");
        [self addSubview:_beanImageView];
        [_beanImageView autoSetDimensionsToSize:CGSizeMake(8, 8)];
        [_beanImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_beanImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_beanImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_beanLabel withOffset:2];
    }
    return self;
}

@end
