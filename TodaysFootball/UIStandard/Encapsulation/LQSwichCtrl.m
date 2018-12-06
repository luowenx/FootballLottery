//
//  LQSwichCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQSwichCtrl.h"

@interface LQSwichCtrl()

@property (nonatomic, strong) UIView * blockView;
@property (nonatomic, strong) UILabel * onTitleLabel;
@property (nonatomic, strong) UILabel * offTitleLabel;

@end

@implementation LQSwichCtrl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self roundedRectWith:15];
        [self autoSetDimensionsToSize:CGSizeMake(150, 30)];
        self.backgroundColor = UIColorFromRGB(0xcccccc);
        
        _blockView = [UIView newAutoLayoutView];
        _blockView.backgroundColor = [UIColor whiteColor];
        [_blockView setCornerRadius:15 borderColor:UIColorFromRGB(0xf2f2f2) borderWidth:1];
        [self addSubview:_blockView];
        [_blockView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_blockView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_blockView autoSetDimensionsToSize:CGSizeMake(75, 30)];
        
        _onTitleLabel = [UILabel newAutoLayoutView];
        _onTitleLabel.textAlignment = NSTextAlignmentCenter;
        _onTitleLabel.font = [UIFont lqsFontOfSize:24];
        [self addSubview:_onTitleLabel];
        [_onTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [_onTitleLabel autoSetDimension:ALDimensionWidth toSize:75];
        
        _offTitleLabel = [UILabel newAutoLayoutView];
        _offTitleLabel.textAlignment = NSTextAlignmentCenter;
        _offTitleLabel.font = [UIFont lqsFontOfSize:24];
        [self addSubview:_offTitleLabel];
        [_offTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [_offTitleLabel autoSetDimension:ALDimensionWidth toSize:75];
    
        [self addTarget:self action:@selector(swichDown) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.on = YES;
    }
    return self;
}

-(void)updateSwithOnTitle:(NSString *)onTitle offTitle:(NSString *)offTitle
{
    self.onTitleLabel.text = onTitle;
    self.offTitleLabel.text = offTitle;
}


-(void)setOn:(BOOL)on
{
    if (on == _on) {
        return;
    }
    _on = on;
    if (on) {
        self.onTitleLabel.textColor = [UIColor flsMainColor];
        self.offTitleLabel.textColor = UIColorFromRGB(0x393939);
    }else{
        self.onTitleLabel.textColor = UIColorFromRGB(0x393939);
        self.offTitleLabel.textColor = [UIColor flsMainColor];
    }
    
    CGRect fromFrame = self.blockView.frame;
    
    CGRect toFrame = CGRectZero;
    if (on) {
        toFrame = CGRectMake(0, fromFrame.origin.y, fromFrame.size.width, fromFrame.size.height);
    }else{
        toFrame = CGRectMake(75, fromFrame.origin.y, fromFrame.size.width, fromFrame.size.height);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blockView.frame = toFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)swichDown
{
    self.on = !self.on;
    if (self.swichAction) {
        self.swichAction(self.on);
    }
}

@end
