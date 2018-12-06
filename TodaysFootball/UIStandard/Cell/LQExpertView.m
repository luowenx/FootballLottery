//
//  LQExpertView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/29.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQExpertView.h"

@implementation LQExpertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avaterView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeSmall)];
        [self addSubview:_avaterView];
        [_avaterView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        
    }
    return self;
}

@end
