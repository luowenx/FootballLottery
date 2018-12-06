//
//  LQPlanDetailCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPlanDetailCell.h"
#import "LQPlayVoObj.h"

@interface LQPlanDetailCell()

@end

@implementation LQPlanDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *topSpace = [UIView newAutoLayoutView];
        topSpace.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:topSpace];
        [topSpace autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [topSpace autoSetDimension:ALDimensionHeight toSize:4];
        
        /*********** 时间状态  ***************/
        _timeStatusView = [PlanTimeStatusView newAutoLayoutView];
        [self.contentView addSubview:_timeStatusView];
        [_timeStatusView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4];
        [_timeStatusView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_timeStatusView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_timeStatusView autoSetDimension:ALDimensionHeight toSize:45];
        
        /*********** 比赛状况  ***************/
        _concedValueLabel = [UILabel newAutoLayoutView];
        _concedValueLabel.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _concedValueLabel.font = [UIFont lqsFontOfSize:24];
        _concedValueLabel.textAlignment = NSTextAlignmentCenter;
        [_concedValueLabel roundedRectWith:5];
        [self.contentView addSubview:_concedValueLabel];
        [_concedValueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [_concedValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_timeStatusView withOffset:94];
        [_concedValueLabel autoSetDimensionsToSize:CGSizeMake(lqPointConvertInScreenWidth4EQScale(44), lqPointConvertInScreenWidth4EQScale(44))];
        
        _concedLabel = [UILabel newAutoLayoutView];
        _concedLabel.text = @"让球";
        _concedLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _concedLabel.font = [UIFont lqsFontOfSize:26];
        [self.contentView addSubview:_concedLabel];
        [_concedLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_concedValueLabel];
        [_concedLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_concedValueLabel withOffset:-15];
        
        UIView *playContentView = [UIView newAutoLayoutView];
        [self.contentView addSubview:playContentView];
        [playContentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_concedValueLabel];
        [playContentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _homeVictoryView = [PlanPlayView newAutoLayoutView];
        [_homeVictoryView roundedRectWith:5 bounds:CGRectMake(0, 0, lqPointConvertInScreenWidth4EQScale(82), lqPointConvertInScreenWidth4EQScale(44)) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)];
        [playContentView addSubview:_homeVictoryView];
        [_homeVictoryView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        
        _homeLabel = [UILabel newAutoLayoutView];
        _homeLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _homeLabel.font = [UIFont lqsFontOfSize:26];
        [self.contentView addSubview:_homeLabel];
        [_homeLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_homeVictoryView];
        [_homeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_concedLabel];
        
        _homeIconView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_homeIconView];
        [_homeIconView autoAlignAxis:ALAxisVertical toSameAxisOfView:_homeVictoryView];
        [_homeIconView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_homeLabel withOffset:-8];
        
        _flatView = [PlanPlayView newAutoLayoutView];
        [playContentView addSubview:_flatView];
        [_flatView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_flatView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_homeVictoryView];
        
        _flatLabel = [UILabel newAutoLayoutView];
        _flatLabel.text = @"VS";
        _flatLabel.textColor = UIColorFromRGB(0x505050);
        _flatLabel.font = [UIFont lqsBEBASFontOfSize:50];
        [self.contentView addSubview:_flatLabel];
        [_flatLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_flatView];
        [_flatLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_homeIconView];
        
        _guestVictoryView = [PlanPlayView newAutoLayoutView];
        [_guestVictoryView roundedRectWith:5 bounds:CGRectMake(0, 0, lqPointConvertInScreenWidth4EQScale(82), lqPointConvertInScreenWidth4EQScale(44)) byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)];
        [playContentView addSubview:_guestVictoryView];
        [_guestVictoryView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [_guestVictoryView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_flatView];
        
        _guestLabel = [UILabel newAutoLayoutView];
        _guestLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _guestLabel.font = [UIFont lqsFontOfSize:26];
        [self.contentView addSubview:_guestLabel];
        [_guestLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_guestVictoryView];
        [_guestLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_concedLabel];
        
        _guestIconView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_guestIconView];
        [_guestIconView autoAlignAxis:ALAxisVertical toSameAxisOfView:_guestVictoryView];
        [_guestIconView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_homeIconView];
        
        UIView *playLine1 = [UIView newAutoLayoutView];
        _playLine1 = playLine1;
        [playContentView addSubview:playLine1];
        [playLine1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_homeVictoryView];
        [playLine1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [playLine1 autoSetDimensionsToSize:CGSizeMake(.5, 20)];
        
        UIView *playLine2 = [UIView newAutoLayoutView];
        _playLine2 = playLine2;
        [playContentView addSubview:playLine2];
        [playLine2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_guestVictoryView];
        [playLine2 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [playLine2 autoSetDimensionsToSize:CGSizeMake(.5, 20)];
        
        UIControl *matchCtrl = [UIControl newAutoLayoutView];
        [self.contentView addSubview:matchCtrl];
        [matchCtrl autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [matchCtrl autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [matchCtrl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_timeStatusView];
        [matchCtrl autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_concedLabel];

        /*********** 倍率变化  ***************/
        UILabel *tipsLabel1 = [UILabel newAutoLayoutView];
        tipsLabel1.textAlignment = NSTextAlignmentCenter;
        tipsLabel1.textColor = UIColorFromRGB(0x7a7a7a);
        tipsLabel1.font = [UIFont lqsFontOfSize:28 isBold:NO];
        tipsLabel1.text = @"澳彩和WELLBET的赔率变化";
        tipsLabel1.userInteractionEnabled = YES;
        [self.contentView addSubview:tipsLabel1];
        [tipsLabel1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [tipsLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:playContentView withOffset:25];
        _tipsLabel1 = tipsLabel1;
        
        _tipsImageView = [UIImageView newAutoLayoutView];
        _tipsImageView.image = imageWithName(@"down_arrow");
        _tipsImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_tipsImageView];
        [_tipsImageView autoSetDimensionsToSize:CGSizeMake(10, 5)];
        [_tipsImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:tipsLabel1];
        [_tipsImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tipsLabel1 withOffset:2];
        
        _oddsView = [PlanAutoOddsView newAutoLayoutView];
        [self.contentView addSubview:_oddsView];
        [_oddsView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_oddsView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_oddsView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsLabel1 withOffset:10];
        NSLayoutConstraint *oddsHeightConst = [_oddsView autoSetDimension:ALDimensionHeight toSize:0];

        @weakify(self)
        [[matchCtrl rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.lookMatch ? self_weak_.lookMatch(self_weak_.dataObj):nil;
        }];
        
        @weakify(oddsHeightConst)
        _oddsView.selfHeight = ^(CGFloat height) {
            oddsHeightConst_weak_.constant = height;
        };
        
        [tipsLabel1 addTapGestureWithBlock:^(UIView *gestureView) {
            if (self_weak_.oddsView.open) {
                return;
            }
            self_weak_.open?self_weak_.open(self_weak_.dataObj):nil;
            self_weak_.oddsView.open = YES;
        }];
        
        [_tipsImageView addTapGestureWithBlock:^(UIView *gestureView) {
            if (self_weak_.oddsView.open) {
                return;
            }
            self_weak_.open?self_weak_.open(self_weak_.dataObj):nil;
            self_weak_.oddsView.open = YES;
        }];
    }
    return self;
}

@end

@implementation PlanTimeStatusView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leagueLabel = [UILabel newAutoLayoutView];
        _leagueLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _leagueLabel.font = [UIFont lqsFontOfSize:22];
        [self addSubview:_leagueLabel];
        [_leagueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:23];
        [_leagueLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor flsSpaceLineColor];
        [self addSubview:line];
        [line autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [line autoSetDimensionsToSize:CGSizeMake(.5, 10)];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leagueLabel withOffset:13];
        
        _startTimeLabel = [UILabel newAutoLayoutView];
        _startTimeLabel.font = [UIFont lqsFontOfSize:22];
        _startTimeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self addSubview:_startTimeLabel];
        [_startTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_startTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line withOffset:13];
        
        _statusButton = [UIButton newAutoLayoutView];
        _statusButton.titleLabel.font =[UIFont lqsFontOfSize:22];
        [_statusButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_statusButton roundedRectWith:2];
        [self addSubview:_statusButton];
        [_statusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_statusButton autoSetDimensionsToSize:CGSizeMake(43, 15)];
        [_statusButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _line = [UIView newAutoLayoutView];
        _line.backgroundColor = [UIColor flsSpaceLineColor];
        [self addSubview:_line];
        [_line autoSetDimension:ALDimensionHeight toSize:.5];
        [_line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
    }
    return self;
}

@end

@implementation PlanPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self autoSetDimensionsToSize:CGSizeMake(lqPointConvertInScreenWidth4EQScale(82), lqPointConvertInScreenWidth4EQScale(44))];
        
        UIView *contentView = [UIView newAutoLayoutView];
        [self addSubview:contentView];
        [contentView autoCenterInSuperview];
        
        _playTitleLabel = [UILabel newAutoLayoutView];
        _playTitleLabel.font = [UIFont lqsFontOfSize:28];
        _playTitleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_playTitleLabel];
        [_playTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_playTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_playTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        _playValueLabel = [UILabel newAutoLayoutView];
        _playValueLabel.font = [UIFont lqsFontOfSize:28];
        _playValueLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_playValueLabel];
        [_playValueLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_playValueLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_playValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_playTitleLabel withOffset:3];
        
        _hookImageView = [UIImageView newAutoLayoutView];
        _hookImageView.image = imageWithName(@"猜对");
        [_hookImageView roundedRectWith:8];
        [self addSubview:_hookImageView];
        [_hookImageView autoSetDimensionsToSize:CGSizeMake(16, 16)];
        
        _hitImageView = [UIImageView newAutoLayoutView];
        _hitImageView.image = imageWithName(@"已中");
        [_hitImageView roundedRectWith:18];
        [_hitImageView autoSetDimensionsToSize:CGSizeMake(36, 36)];
    }
    return self;
}

-(void)layoutSubviews
{
    [self.superview addSubview:_hitImageView];
    [_hitImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [_hitImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:-15];
    
    [self.superview addSubview:_hookImageView];
    [_hookImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-5];
    [_hookImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:8];
    
    [super layoutSubviews];
}

-(void)setOutcome:(NSInteger)outcome isRecommend:(BOOL)isRecommend
{
    switch (outcome) {
        case 0:{

            break;
        }
        case 1:{
            
            break;
        }
        case 2:{

            break;
        }
            
        default:
            break;
    }
    self.backgroundColor = isRecommend?UIColorFromRGB(0xcdb38b): UIColorFromRGB(0xf2f2f2);
    self.playTitleLabel.textColor = isRecommend?[UIColor whiteColor] : UIColorFromRGB(0x7a7a7a);
    self.playValueLabel.textColor = isRecommend?[UIColor whiteColor] : UIColorFromRGB(0x7a7a7a);
}

@end

@implementation __OddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [UIView newAutoLayoutView];
        [self addSubview:contentView];
        [contentView autoCenterInSuperview];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.font = [UIFont lqsFontOfSize:24];
        _titleLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_titleLabel];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        _subTitleLabel = [UILabel newAutoLayoutView];
        _subTitleLabel.font = [UIFont lqsFontOfSize:24];
        _subTitleLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_subTitleLabel];
        [_subTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_subTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_subTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:5];
        [_subTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
    }
    return self;
}

@end

@implementation PlanAutoOddsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)reloadView
{
    if (!self.isOpen) {
        self.selfHeight?self.selfHeight(0):nil;
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    
    for (UIView *abandonedView in self.subviews) { // 移除之间加的
        [abandonedView removeFromSuperview];
    }
    
    NSInteger lineNum = self.oddData.count;
    LQExtraOdds *odd = self.oddData.firstObject;
    NSInteger num = odd.itemOddsList.count;
    
    CGFloat itemHeight = lqPointConvertInScreenWidth4EQScale(57.5);

    CGFloat typeItemWidth = lqPointConvertInScreenWidth4EQScale(50);

    CGFloat itemWidth = lqPointConvertInScreenWidth4EQScale((mt_iPhone5? 238 : 240)/num);

    if (self.selfHeight) {
        self.selfHeight(lineNum * itemHeight);
    }
    
    UIView *previousLine = nil;  // 上一行
    for (LQExtraOdds *odd in self.oddData) {

        UILabel *typeLabel = [UILabel newAutoLayoutView];
        typeLabel.backgroundColor = UIColorFromRGB(0xf2f2f2);
        typeLabel.textColor = UIColorFromRGB(0x7a7a7a);
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.text = stringNotNil(odd.oddsCompany);
        typeLabel.font = [UIFont lqsFontOfSize:24];
        [self addSubview:typeLabel];
        [typeLabel autoSetDimensionsToSize:CGSizeMake(typeItemWidth + 10, itemHeight)];
        [typeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        if (previousLine) {
            [typeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousLine];
            [typeLabel roundedRectWith:5 bounds:CGRectMake(0, 0, typeItemWidth + 10, itemHeight) byRoundingCorners:(UIRectCornerBottomLeft)];
        }else{
            [typeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [typeLabel roundedRectWith:5 bounds:CGRectMake(0, 0, typeItemWidth + 10, itemHeight) byRoundingCorners:(UIRectCornerTopLeft)];
        }
        previousLine = typeLabel;
        
        __OddView *discView = [__OddView newAutoLayoutView];
        discView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        discView.titleLabel.text = @"初盘";
        discView.subTitleLabel.text = @"即时";
        [self addSubview:discView];
        [discView autoSetDimensionsToSize:CGSizeMake(typeItemWidth - 10, itemHeight)];
        [discView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:typeLabel];
        [discView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:typeLabel];
        
        // 倍率
        UIView *previousView = nil;  //  上一个
        for (LQItemOdds *itemOdd in odd.itemOddsList) {
            
            __OddView *oddView = [__OddView newAutoLayoutView];
            oddView.backgroundColor = UIColorFromRGB(0xf2f2f2);
            oddView.titleLabel.text = [NSString stringWithFormat:@"%.2f", itemOdd.originOdds];
            oddView.subTitleLabel.text = [NSString stringWithFormat:@"%.2f", itemOdd.currentOdds];
            
            if (itemOdd.currentOdds ==  itemOdd.originOdds) {
                oddView.subTitleLabel.textColor = UIColorFromRGB(0xa2a2a2);
            }else if (itemOdd.currentOdds >  itemOdd.originOdds){
                oddView.subTitleLabel.textColor = [UIColor flsMainColor];
            }else{
                oddView.subTitleLabel.textColor = UIColorFromRGB(0x71c671);
            }
            
            [self addSubview:oddView];
            [oddView autoSetDimensionsToSize:CGSizeMake(itemWidth, itemHeight)];
            [oddView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:typeLabel];
            if (previousView) {
                [oddView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
            }else{
                [oddView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:discView withOffset:0];
            }
            
            if ([self.oddData indexOfObject:odd] == 0 && [odd.itemOddsList indexOfObject:itemOdd]+1 == odd.itemOddsList.count) {
                [oddView roundedRectWith:5 bounds:CGRectMake(0, 0, itemWidth, itemHeight) byRoundingCorners:(UIRectCornerTopRight)];
            }
            
            if ([self.oddData indexOfObject:odd]+ 1 == self.oddData.count && [odd.itemOddsList indexOfObject:itemOdd]+1 == odd.itemOddsList.count) {
                [oddView roundedRectWith:5 bounds:CGRectMake(0, 0, itemWidth, itemHeight) byRoundingCorners:(UIRectCornerBottomRight)];
            }

            previousView = oddView;
        }
    }

    // 添加线条
    // 1、横线
    for (int i = 0; i < MAX(0, self.oddData.count -1); i++) {
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xc6c6c6);
        [self addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:23];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(UIDeviceScreenWidth == 320)?17:28];
        [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:itemHeight * (i + 1)];

        
//        UIView *lineLeft = [UIView newAutoLayoutView];
//        lineLeft.backgroundColor = UIColorFromRGB(0xc6c6c6);
//        [self addSubview:lineLeft];
//        [lineLeft autoSetDimensionsToSize:CGSizeMake(typeItemWidth * 2 - 12, .5)];
//        [lineLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:23];
//        [lineLeft autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:itemHeight * (i + 1)];
//
//        UIView *lineRight = [UIView newAutoLayoutView];
//        lineRight.backgroundColor = UIColorFromRGB(0xc6c6c6);
//        [self addSubview:lineRight];
//        [lineRight autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(UIDeviceScreenWidth == 320)?17:28];
//        [lineRight autoSetDimensionsToSize:CGSizeMake(itemWidth * num - 17, .5)];
//        [lineRight autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:itemHeight * (i + 1)];
    }
    
    // 1、竖线
    CGFloat lineHeight = lineNum * itemHeight - 18;
    
    UIView *verticalLineLeft = [UIView newAutoLayoutView];
    verticalLineLeft.backgroundColor = UIColorFromRGB(0xc6c6c6);
    [self addSubview:verticalLineLeft];
    [verticalLineLeft autoSetDimensionsToSize:CGSizeMake(.5, lineHeight)];
    [verticalLineLeft autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:9];
    [verticalLineLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:typeItemWidth + 27];

    for (int j = 0; j<MAX(0, num); j++) {
        UIView *verticalLine = [UIView newAutoLayoutView];
        verticalLine.backgroundColor = UIColorFromRGB(0xc6c6c6);
        [self addSubview:verticalLine];
        [verticalLine autoSetDimensionsToSize:CGSizeMake(.5, lineHeight)];
        [verticalLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:9];
        [verticalLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17 + itemWidth * (j + 1)];
    }
}


-(void)setOpen:(BOOL)open
{
    _open = open;
    [self reloadView];
}

@end

