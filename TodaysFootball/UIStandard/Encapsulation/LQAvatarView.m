//
//  LQAvatarView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAvatarView.h"

@implementation LQAvatarView

-(instancetype)initWithLength:(CGFloat)length grade:(LQAvatarViewGrade)grade
{
    return [self initWithLength:length ringWidth:grade* 0.5];
}

-(instancetype)initWithLength:(CGFloat)length ringWidth:(CGFloat)ringWidth
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self autoSetDimensionsToSize:CGSizeMake(length, length)];
        [self roundedRectWith:length/2];
        self.backgroundColor = UIColorFromRGB(0xd2d2d2);
        
        _avatarImageView = [UIImageView newAutoLayoutView];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView roundedRectWith:(length - ringWidth)/2];
        [self addSubview:_avatarImageView];
        [_avatarImageView autoCenterInSuperview];
        [_avatarImageView autoSetDimensionsToSize:CGSizeMake(length - ringWidth, length - ringWidth)];
    }
    return self;
}


@end
