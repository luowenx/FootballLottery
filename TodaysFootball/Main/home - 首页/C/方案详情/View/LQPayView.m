//
//  LQPayView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPayView.h"
#import "LQAvailableCoupon.h"
@interface LQPayView()

@property (nonatomic, strong) UILabel *fullLabel;
@property (nonatomic, strong) UILabel *overdueLabel;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LQPayView{
    UIView *bgView;
    UIButton *payBtn;
    UIView *overdueView;
    
    // 有优惠券
    UILabel *discountPriceLabel;
    UILabel *discountLabel;
    UILabel *discountTipsLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self autoSetDimension:ALDimensionHeight toSize:51 + kLQSafeBottomHeight];

        payBtn = [UIButton newAutoLayoutView];
        [payBtn setBackgroundColor:[UIColor flsMainColor]];
        [payBtn setTitleColor:UIColorFromRGB(0xf2f2f2) forState:(UIControlStateNormal)];
        [payBtn setTitle:@"立即支付" forState:(UIControlStateNormal)];
        [payBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, kLQSafeBottomHeight + 10, 0)];
        [self addSubview:payBtn];
        [payBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [payBtn autoSetDimension:ALDimensionWidth toSize:123];
        
        bgView = [UIView newAutoLayoutView];
        [self addSubview:bgView];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:payBtn];
        
        UIView *contentView = [UIView newAutoLayoutView];
        [self addSubview:contentView];
        [contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [contentView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-kLQSafeBottomHeight/2];
        [contentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:123];
        _contentView = contentView;
        
        discountPriceLabel = [UILabel newAutoLayoutView];
        discountPriceLabel.text = @"";
        discountPriceLabel.textColor = [UIColor flsMainColor];
        discountPriceLabel.font = [UIFont lqsFontOfSize:30];
        [contentView addSubview:discountPriceLabel];
        [discountPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [discountPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        discountLabel = [UILabel newAutoLayoutView];
        discountLabel.font = [UIFont lqsFontOfSize:22];
        discountLabel.textColor = UIColorFromRGB(0xf2f2f2);
        [contentView addSubview:discountLabel];
        [discountLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:discountPriceLabel];
        [discountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:discountPriceLabel withOffset:15];
        
        discountTipsLabel = [UILabel newAutoLayoutView];
        discountTipsLabel.font = [UIFont lqsFontOfSize:22];
        discountTipsLabel.text =@"您有可用的优惠券";
        discountTipsLabel.textColor = UIColorFromRGB(0xf2f2f2);
        [contentView addSubview:discountTipsLabel];
        [discountTipsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [discountTipsLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [discountTipsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:discountPriceLabel withOffset:8];
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        imageView.image = imageWithName(@"向下箭头");
        [contentView addSubview:imageView];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoSetDimensionsToSize:CGSizeMake(19, 11)];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
        
        _fullLabel = [UILabel newAutoLayoutView];
        _fullLabel.textColor = [UIColor flsMainColor];
        _fullLabel.font = [UIFont lqsFontOfSize:30];
        [self addSubview:_fullLabel];
        [_fullLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_fullLabel autoSetDimension:ALDimensionHeight toSize:51];
        [_fullLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        
        overdueView = [UIView newAutoLayoutView];
        overdueView.backgroundColor = UIColorFromRGB(0xa2a2a2);
        overdueView.hidden = YES;
        [self addSubview:overdueView];
        [overdueView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        _overdueLabel = [UILabel newAutoLayoutView];
        _overdueLabel.textColor = [UIColor whiteColor];
        _overdueLabel.font = [UIFont lqsFontOfSize:34];
        _overdueLabel.text = @"比赛进行中，无法购买";
        _overdueLabel.textAlignment = NSTextAlignmentCenter;
        [overdueView addSubview:_overdueLabel];
        [_overdueLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [_overdueLabel autoSetDimension:ALDimensionHeight toSize:51];
        
        @weakify(self)
        [[payBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            
            self_weak_.pay?self_weak_.pay():nil;
        }];
        
        [contentView addTapGestureWithBlock:^(UIView *gestureView) {
            
            self_weak_.chooseDiscount?self_weak_.chooseDiscount():nil;
        }];
    }
    return self;
}

-(void)setColorbean:(NSInteger)colorbean discount:(LQAvailableCoupon *)coupon
{
    if (coupon == nil) { // 无优惠券
        self.fullLabel.hidden = NO;
        self.contentView.hidden = YES;
        self.fullLabel.text = [NSString stringWithFormat:@"%@乐豆", @(colorbean)];
        return;
    }
    
    // 有优惠券
    self.fullLabel.hidden = YES;
    self.contentView.hidden = NO;
    
    if (coupon.used) { // 使用优惠券
        discountPriceLabel.text = [NSString stringWithFormat:@"%@乐豆", @(coupon.realCost)];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@乐豆)", @(colorbean)]
                                                                                         attributes:@{NSFontAttributeName:[UIFont lqsFontOfSize:22],
                                                                                                      NSForegroundColorAttributeName:UIColorFromRGB(0xf2f2f2),
                                                                                                      NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                                      NSStrikethroughColorAttributeName:UIColorFromRGB(0xf2f2f2)
                                                                                                      }];
        discountLabel.attributedText = attributeStr;
        
        discountTipsLabel.text = coupon.tips;
    }else{// 不使用优惠券
        discountPriceLabel.text = [NSString stringWithFormat:@"%@乐豆", @(colorbean)];
        discountLabel.attributedText = nil;
        discountTipsLabel.text = @"您有可用的优惠卷";
    }
}



-(void)setShowType:(LQPlanDetailShowType)showType
{
    _showType = showType;
    switch (showType) {
        case LQPlanDetailShowTypeUnknown:
        case LQPlanDetailShowTypeShowContent:
        case LQPlanDetailShowTypeBeginTips:
        case LQPlanDetailShowTypeCountdown:
            break;
        case LQPlanDetailShowTypeUnderway:{
            overdueView.hidden = NO;
            self.userInteractionEnabled = NO;
            bgView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

@end
