//
//  LQTitleView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/4.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQTitleView.h"

@interface LQTitleView()

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation LQTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor flsMainColor];
        [self autoSetDimensionsToSize:CGSizeMake(UIDeviceScreenWidth, kLQNavANDStatusBarHeight)];
        
        _backgroundView = [UIImageView newAutoLayoutView];
        [self addSubview:_backgroundView];
        [_backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

        _titleView = [UIView newAutoLayoutView];
        [self addSubview:_titleView];
        [_titleView autoSetDimension:ALDimensionHeight toSize:kLQNavHeight];
        [_titleView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_titleView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_titleView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont lqsFontOfSize:36];
        [_titleView addSubview:_titleLabel];
        [_titleLabel autoCenterInSuperview];
        
        _leftButton = [UIButton newAutoLayoutView];
        [self addSubview:_leftButton];
        [_leftButton autoSetDimensionsToSize:CGSizeMake(44, 44)];
        [_leftButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_titleView];
        [_leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    }
    return self;
}

-(void)setRightView:(UIView *)rightView
{
    if (!rightView) {return;}
    if (_rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    _rightView = rightView;
    [self addSubview:rightView];
    [rightView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_titleView];
    [rightView autoSetDimension:ALDimensionHeight toSize:kLQNavHeight];
    [rightView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
}

-(void)setTitleView:(UIView *)titleView
{
    if (!titleView) { return; }
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    _titleView = titleView;
    [self addSubview:titleView];
    [titleView autoSetDimension:ALDimensionHeight toSize:kLQNavHeight];
    [titleView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100 relation:(NSLayoutRelationGreaterThanOrEqual)];
}

-(void)updateLeftTitle:(NSString *)leftTitle handler:(void(^)(UIButton *sender))handler
{
    [self.leftButton setTitle:leftTitle forState:(UIControlStateNormal)];
    [[self.leftButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        handler?handler(x):nil;
    }];
}

-(void)updateLeftImageName:(NSString *)leftImage handler:(void(^)(UIButton *sender))handler
{
    [self.leftButton setImage:imageWithName(leftImage) forState:(UIControlStateNormal)];
    [[self.leftButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        handler?handler(x):nil;
    }];
}

@end
