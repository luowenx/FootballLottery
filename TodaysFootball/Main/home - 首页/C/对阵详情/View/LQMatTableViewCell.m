//
//  LQMatTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/1.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatTableViewCell.h"

@implementation LQMatTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeSmall)];
        [self.contentView addSubview:_avatarView];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingSpecial];
        
        UIView *userView = [UIView newAutoLayoutView];
        [self.contentView addSubview:userView];
        [userView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarView withOffset:10];
        [userView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_avatarView];
        
        _expertNameLabel = [UILabel newAutoLayoutView];
        _expertNameLabel.font = [UIFont lqsFontOfSize:32];
        _expertNameLabel.textColor = UIColorFromRGB(0x404040);
        [userView addSubview:_expertNameLabel];
        [_expertNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_expertNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_expertNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _expertDescriptionLabel = [UILabel newAutoLayoutView];
        _expertDescriptionLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _expertDescriptionLabel.font = [UIFont lqsFontOfSize:22];
        [userView addSubview:_expertDescriptionLabel];
        [_expertDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_expertDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_expertDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        [_expertDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_expertNameLabel withOffset:8];
        
        _hitRateLabel = [UILabel newAutoLayoutView];
        _hitRateLabel.font = [UIFont lqsBEBASFontOfSize:50];
        _hitRateLabel.textColor = [UIColor flsMainColor];
        [self.contentView addSubview:_hitRateLabel];
        [_hitRateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
        [_hitRateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        UIImageView *hitRateImageView = [UIImageView newAutoLayoutView];
        hitRateImageView.image = imageWithName(@"百分比");
        [self.contentView addSubview:hitRateImageView];
        [hitRateImageView autoSetDimensionsToSize:CGSizeMake(8, 8)];
        [hitRateImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_hitRateLabel];
        [hitRateImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_hitRateLabel withOffset:8];
        RAC(hitRateImageView, hidden) = RACObserve(_hitRateLabel, hidden);
        
        _hitDesLabel = [UILabel newAutoLayoutView];
        _hitDesLabel.textColor = [UIColor flsMainColor];
        _hitDesLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_hitDesLabel];
        [_hitDesLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:22];
        [_hitDesLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_hitRateLabel withOffset:5];
        RAC(_hitDesLabel, hidden) = RACObserve(_hitRateLabel, hidden);
        
        _straightLabel = [UILabel newAutoLayoutView];
        _straightLabel.textColor = [UIColor flsMainColor];
        _straightLabel.font = [UIFont lqsFontOfSize:24];
        _straightLabel.layer.cornerRadius = 7.5;
        _straightLabel.layer.borderColor = [UIColor flsMainColor].CGColor;
        _straightLabel.layer.borderWidth = 1.0;
        _straightLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_straightLabel];
        [_straightLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_avatarView];
        [_straightLabel autoSetDimensionsToSize:CGSizeMake(50, 15)];
        [_straightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70];
        
        //        _scheduleLable = [UILabel newAutoLayoutView];
        //        _scheduleLable.textColor = [UIColor flsMainColor];
        //        _scheduleLable.font = [UIFont lqsFontOfSize:24];
        //        _scheduleLable.layer.cornerRadius = 7.5;
        //        _scheduleLable.layer.borderColor = [UIColor flsMainColor].CGColor;
        //        _scheduleLable.layer.borderWidth = 1.0;
        //        _scheduleLable.textAlignment = NSTextAlignmentCenter;
        //        [self.contentView addSubview:_scheduleLable];
        //        [_scheduleLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_avatarView];
        //        [_scheduleLable autoSetDimensionsToSize:CGSizeMake(53, 15)];
        //        [_scheduleLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userView withOffset:10];
        
        UIView *titleView = [UIView newAutoLayoutView];
        [self.contentView addSubview:titleView];
        [titleView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_avatarView];
        [titleView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        [titleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_avatarView withOffset:kLQSPaddingLarge];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        _titleLabel.font = [UIFont lqsFontOfSize:32];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        [titleView addSubview:_titleLabel];
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.font = [UIFont lqsFontOfSize:20];
        _timeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_timeLabel];
        [_timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_avatarView];
        [_timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView withOffset:kLQSPaddingLarge];
        
        UIView *timeLine = [UIView newAutoLayoutView];
        timeLine.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:timeLine];
        [timeLine autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [timeLine autoSetDimensionsToSize:CGSizeMake(.5, 10)];
        [timeLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeLabel withOffset:10];
        
        _lookButton = [UIButton newAutoLayoutView];
        [_lookButton setTitleColor:UIColorFromRGB(0xa2a2a2) forState:(UIControlStateNormal)];
        [_lookButton setTitle:@"查看" forState:(UIControlStateNormal)];
        _lookButton.titleLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_lookButton];
        [_lookButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_lookButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:timeLine withOffset:10];
        
        _lookNumbersLabel = [UILabel newAutoLayoutView];
        _lookNumbersLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _lookNumbersLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_lookNumbersLabel];
        [_lookNumbersLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_lookNumbersLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _beanView = [LQBeanView newAutoLayoutView];
        [self.contentView addSubview:_beanView];
        [_beanView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_beanView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:timeLine withOffset:10];
        
        _hitRollBtn = [UIButton newAutoLayoutView];
        _hitRollBtn.titleLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        [_hitRollBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_hitRollBtn setTitle:@"红" forState:(UIControlStateNormal)];
        [_hitRollBtn setTitle:@"黑" forState:(UIControlStateSelected)];
        [_hitRollBtn setBackgroundImage:imageWithName(@"红") forState:(UIControlStateNormal)];
        [_hitRollBtn setBackgroundImage:imageWithName(@"黑") forState:(UIControlStateSelected)];
        [self.contentView addSubview:_hitRollBtn];
        [_hitRollBtn autoSetDimensionsToSize:CGSizeMake(20, 20)];
        [_hitRollBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_hitRollBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        
        _matchStatusLabel = [UILabel newAutoLayoutView];
        _matchStatusLabel.textColor = [UIColor whiteColor];
        _matchStatusLabel.font = [UIFont lqsFontOfSize:20];
        _matchStatusLabel.textAlignment = NSTextAlignmentCenter;
        [_matchStatusLabel roundedRectWith:3];
        [self.contentView addSubview:_matchStatusLabel];
        [_matchStatusLabel autoSetDimensionsToSize:CGSizeMake(44, 15)];
        [_matchStatusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_matchStatusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_avatarView];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        @weakify(self)
        [_avatarView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.persobAction?self_weak_.persobAction(self_weak_.dataObj):nil;
        }];
        
        [userView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.persobAction?self_weak_.persobAction(self_weak_.dataObj):nil;
        }];
    }
    return self;
}

+(CGFloat)staticHeight
{
    // 17 + 44 + 15 + 15 + 20 + [UIFont lqsFontOfSize:20].lineHeight
    return 111 + [UIFont lqsFontOfSize:20].lineHeight;
}

@end
