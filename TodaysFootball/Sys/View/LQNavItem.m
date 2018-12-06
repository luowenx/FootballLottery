//
//  LQNavItem.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/25.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQNavItem.h"

@implementation LQNavItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = NO;
        [self addSubview:_imageView];
        [_imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_imageView autoSetDimensionsToSize:CGSizeMake(44, 44)];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        _titlLabel = [UILabel newAutoLayoutView];
        [self addSubview:_titlLabel];
        [_titlLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_titlLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    }
    return self;
}


@end
