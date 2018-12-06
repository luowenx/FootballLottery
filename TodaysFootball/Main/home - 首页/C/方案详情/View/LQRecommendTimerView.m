//
//  LQRecommendTimerView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQRecommendTimerView.h"

@interface LQRecommendTimerView ()

@property (nonatomic, strong) UIButton * timeButton;
@property (nonatomic, strong) UIButton * branchButton;
@property (nonatomic, strong) UIButton * secondButton;

@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation LQRecommendTimerView
{
    UILabel *tipsLabel;     // 比赛开始、可继续购买
    UILabel *tipsLabel1;    //支付后显示投注方案以及理由
    UILabel *tipsLabel2;    //距禁止售卖
    UIImageView *colon1;
    UIImageView *colon2;
    NSLayoutConstraint *consTips1Top;
    NSLayoutConstraint *consSpeceHeight;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topLine = [UIView newAutoLayoutView];
        topLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:topLine];
        [topLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [topLine autoSetDimension:ALDimensionHeight toSize:4];
        
        UILabel *reasonLabel = [UILabel newAutoLayoutView];
        reasonLabel.text = @"推荐理由：";
        reasonLabel.font = [UIFont lqsFontOfSize:28];
        reasonLabel.textColor = UIColorFromRGB(0x393939);
        [self addSubview:reasonLabel];
        [reasonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topLine withOffset:15];
        [reasonLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        
        tipsLabel = [UILabel newAutoLayoutView];
        tipsLabel.hidden = YES;
        tipsLabel.font = [UIFont lqsFontOfSize:26];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"本方案中有比赛已开始，但您仍可继续购买。"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor flsMainColor] range:NSMakeRange(0, 11)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa7a7a7) range:NSMakeRange(11, 9)];
        tipsLabel.attributedText = attributedStr;
        [self addSubview:tipsLabel];
        [tipsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:reasonLabel];
        [tipsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:reasonLabel withOffset:10];

        tipsLabel1 = [UILabel newAutoLayoutView];
        tipsLabel1.textColor = UIColorFromRGB(0xa7a7a7);
        tipsLabel1.font = [UIFont lqsFontOfSize:26];
        tipsLabel1.text = @"支付后显示投注方案以及理由";
        [self addSubview:tipsLabel1];
        [tipsLabel1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        consTips1Top = [tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:45];
        
        tipsLabel2 = [UILabel newAutoLayoutView];
        tipsLabel2.textColor = UIColorFromRGB(0xa7a7a7);
        tipsLabel2.font = [UIFont lqsFontOfSize:26];
        tipsLabel2.text = @"距禁止售卖";
        [self addSubview:tipsLabel2];
        [tipsLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:tipsLabel1];
        [tipsLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsLabel1 withOffset:18];
        
        _timeButton = [UIButton newAutoLayoutView];
        _timeButton.titleLabel.font = [UIFont lqsFontOfSize:33 isBold:YES];
        [_timeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_timeButton setTitle:@"00" forState:(UIControlStateNormal)];
        [_timeButton setBackgroundImage:imageWithName(@"计时块") forState:(UIControlStateNormal)];
        [self addSubview:_timeButton];
        [_timeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel2];
        [_timeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tipsLabel2 withOffset:12];
        [_timeButton autoSetDimensionsToSize:CGSizeMake(25, 30)];
        
        colon1 = [UIImageView newAutoLayoutView];
        colon1.image = imageWithName(@"时间冒号");
        [self addSubview:colon1];
        [colon1 autoSetDimensionsToSize:CGSizeMake(4, 11)];
        [colon1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel2];
        [colon1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeButton withOffset:3];
        
        _branchButton = [UIButton newAutoLayoutView];
        _branchButton.titleLabel.font = [UIFont lqsFontOfSize:33 isBold:YES];
        [_branchButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_branchButton setTitle:@"00" forState:(UIControlStateNormal)];
        [_branchButton setBackgroundImage:imageWithName(@"计时块") forState:(UIControlStateNormal)];
        [self addSubview:_branchButton];
        [_branchButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel2];
        [_branchButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:colon1 withOffset:3];
        [_branchButton autoSetDimensionsToSize:CGSizeMake(25, 30)];
        
        colon2 = [UIImageView newAutoLayoutView];
        colon2.image = imageWithName(@"时间冒号");
        [self addSubview:colon2];
        [colon2 autoSetDimensionsToSize:CGSizeMake(4, 11)];
        [colon2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel2];
        [colon2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_branchButton withOffset:3];
        
        _secondButton = [UIButton newAutoLayoutView];
        _secondButton.titleLabel.font = [UIFont lqsFontOfSize:33 isBold:YES];
        [_secondButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_secondButton setTitle:@"00" forState:(UIControlStateNormal)];
        [_secondButton setBackgroundImage:imageWithName(@"计时块") forState:(UIControlStateNormal)];
        [self addSubview:_secondButton];
        [_secondButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel2];
        [_secondButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:colon2 withOffset:3];
        [_secondButton autoSetDimensionsToSize:CGSizeMake(25, 30)];
        
        
        UIView *speceView = [UIView newAutoLayoutView];
        speceView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:speceView];
        [speceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        consSpeceHeight = [speceView autoSetDimension:ALDimensionHeight toSize:(is_iPhoneX? 85:51)];
        
        UILabel *tipsLabel3 = [UILabel newAutoLayoutView];
        tipsLabel3.textColor = UIColorFromRGB(0xa2a2a2);
        tipsLabel3.backgroundColor = UIColorFromRGB(0xf2f2f2);
        tipsLabel3.font = [UIFont lqsFontOfSize:20];
        tipsLabel3.textAlignment = NSTextAlignmentCenter;
        tipsLabel3.text = @"观点建议仅供参考，投注需谨慎 ！";
        [self addSubview:tipsLabel3];
        [tipsLabel3 autoSetDimension:ALDimensionHeight toSize:25];
        [tipsLabel3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [tipsLabel3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [tipsLabel3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:speceView];
    }
    return self;
}

-(void)setShowType:(LQPlanDetailShowType)showType
{
    _showType = showType;
    switch (showType) {
        case LQPlanDetailShowTypeUnknown:
        case LQPlanDetailShowTypeShowContent: // 不会显示当前视图不处理
        case LQPlanDetailShowTypeCountdown:// 正常显示不处理
            break;
        case LQPlanDetailShowTypeBeginTips:{ // 显示开始比赛提示
            tipsLabel.hidden = NO;
            consTips1Top.constant = 70;
            break;
        }
        case LQPlanDetailShowTypeUnderway:{
            tipsLabel.hidden = YES;
            [self endTheTimer];
            break;
        }
        default:
            break;
    }
}

-(CGFloat)totalHeight
{
    switch (_showType) {
        case LQPlanDetailShowTypeCountdown:
            return 192 + kLQSafeBottomHeight;
        case LQPlanDetailShowTypeBeginTips:
            return 224 + kLQSafeBottomHeight;
        case LQPlanDetailShowTypeUnderway:
            return 160 + kLQSafeBottomHeight;
        default:
            return 0;
    }
}

-(void)endTheTimer
{
    consTips1Top.constant = 45;
    tipsLabel1.text = @"方案售卖已结束";
    tipsLabel2.hidden = YES;
    colon1.hidden = YES;
    colon2.hidden = YES;
    self.timeButton.hidden = YES;
    self.branchButton.hidden = YES;
    self.secondButton.hidden = YES;
    if (_disposable && !_disposable.isDisposed) {
        [_disposable dispose];
        _disposable = nil;
    }
}

-(void)updateTimeInterval:(NSTimeInterval)interval
{
    if (interval<0) {
        interval = 0;
    }
    
    __block NSTimeInterval surplusInterval = interval;
    if (_disposable && !_disposable.isDisposed) {
        [_disposable dispose];
        _disposable = nil;
    }
    
    @weakify(self)
    _disposable = [[[RACSignal interval:1 onScheduler:([RACScheduler mainThreadScheduler])] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {

        [self_weak_ reloadInterval:surplusInterval];
        if (surplusInterval <= 0) {
            [self_weak_.disposable dispose];
            self_weak_.disposable = nil;
            self_weak_.completeTimer?self_weak_.completeTimer():nil;
        }
        surplusInterval--;
    }];
}

- (void)reloadInterval:(long)interval
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",interval/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(interval%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",interval%60];
    
    [self.timeButton setTitle:str_hour forState:(UIControlStateNormal)];
    [self.branchButton setTitle:str_minute forState:(UIControlStateNormal)];
    [self.secondButton setTitle:str_second forState:(UIControlStateNormal)];
}


@end
