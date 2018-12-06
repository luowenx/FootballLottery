//
//  LQHomeMainTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHomeMainTableViewCell.h"

@implementation LQHomeMainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeSmall)];
        [self.contentView addSubview:_avatarView];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:17];
        
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
        [_hitRateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_avatarView withOffset:-5];
        
        UIImageView *hitRateImageView = [UIImageView newAutoLayoutView];
        hitRateImageView.image = imageWithName(@"百分比");
        [self.contentView addSubview:hitRateImageView];
        [hitRateImageView autoSetDimensionsToSize:CGSizeMake(8, 8)];
        [hitRateImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_hitRateLabel];
        [hitRateImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_hitRateLabel withOffset:8];
        _signView = hitRateImageView;
        
        _hitDesLabel = [UILabel newAutoLayoutView];
        _hitDesLabel.textColor = [UIColor flsMainColor];
        _hitDesLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_hitDesLabel];
        [_hitDesLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:22];
        [_hitDesLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_avatarView withOffset:0];
        
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
        [titleView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
//        [titleView autoSetDimension:ALDimensionHeight toSize:75];
        [titleView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [titleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_avatarView withOffset:15];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        _titleLabel.font = [UIFont lqsFontOfSize:32];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        [titleView addSubview:_titleLabel];
        [_titleLabel autoCenterInSuperview];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        UIView *matchView = [UIView newAutoLayoutView];
        matchView.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:matchView];
        [matchView autoSetDimension:ALDimensionHeight toSize:25];
        [matchView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_avatarView];
        [matchView autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:17];
        [matchView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView withOffset:15];
        _matchView = matchView;
        
        UILabel *VSLabel = [UILabel newAutoLayoutView];
        VSLabel.text = @"VS";
        VSLabel.textColor = UIColorFromRGB(0x7a7a7a);
        VSLabel.font = [UIFont lqsFontOfSize:24 isBold:YES];
        _VSLabel = VSLabel;
        [matchView addSubview:VSLabel];
        [VSLabel autoCenterInSuperview];
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired) forConstraints:^{
            [VSLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
            [VSLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        }];
        
        UIView *matchLineLeft = [UIView newAutoLayoutView];
        matchLineLeft.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [matchView addSubview:matchLineLeft];
        [matchLineLeft autoSetDimensionsToSize:CGSizeMake(.5, 18)];
        [matchLineLeft autoAlignAxisToSuperviewAxis:(ALAxisHorizontal)];
        [matchLineLeft autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineLeft.superview withOffset:-.25 * UIDeviceScreenWidth];
        
        UIView *matchLineRight = [UIView newAutoLayoutView];
        matchLineRight.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [matchView addSubview:matchLineRight];
        [matchLineRight autoSetDimensionsToSize:CGSizeMake(.5, 18)];
        [matchLineRight autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [matchLineRight autoAlignAxis:ALAxisVertical toSameAxisOfView:matchLineRight.superview withOffset: .25 * UIDeviceScreenWidth];

        _matchLabel = [UILabel newAutoLayoutView];
        _matchLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _matchLabel.font = [UIFont lqsFontOfSize:24];
        _matchLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_matchLabel];
        [_matchLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [_matchLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_matchLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineLeft withOffset:-5];
        
        _ranksLeftLabel = [UILabel newAutoLayoutView];
        _ranksLeftLabel.textColor =UIColorFromRGB(0x7a7a7a);
        _ranksLeftLabel.font = [UIFont lqsFontOfSize:24];
        _ranksLeftLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_ranksLeftLabel];
        [_ranksLeftLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_ranksLeftLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineLeft];
        [_ranksLeftLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:VSLabel];
        
        _ranksRightLabel = [UILabel newAutoLayoutView];
        _ranksRightLabel.textColor =UIColorFromRGB(0x7a7a7a);
        _ranksRightLabel.font = [UIFont lqsFontOfSize:24];
        _ranksRightLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_ranksRightLabel];
        [_ranksRightLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_ranksRightLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:VSLabel];
        [_ranksRightLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:matchLineRight];
        
        UIImageView *id_imageView = [UIImageView newAutoLayoutView];
        id_imageView.image  = imageWithName(@"更多");
        [matchView addSubview:id_imageView];
        [id_imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [id_imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [id_imageView autoSetDimensionsToSize:CGSizeMake(5, 10)];
        _cornerView = id_imageView;
        
        _scoreLabel = [UILabel newAutoLayoutView];
        _scoreLabel.textColor =UIColorFromRGB(0xa2a2a2);
        _scoreLabel.font = [UIFont lqsFontOfSize:24];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        [matchView addSubview:_scoreLabel];
        [_scoreLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_scoreLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:matchLineRight];
        [_scoreLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:id_imageView];
        
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.font = [UIFont lqsFontOfSize:20];
        _timeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_timeLabel];
        [_timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_avatarView];
        [_timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:matchView withOffset:20];
        
        UIView *timeLine = [UIView newAutoLayoutView];
        timeLine.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:timeLine];
        [timeLine autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [timeLine autoSetDimensionsToSize:CGSizeMake(.5, 10)];
        [timeLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_timeLabel withOffset:10];
        _timeLine = timeLine;
        
        _beanView = [LQBeanView newAutoLayoutView];
        [self.contentView addSubview:_beanView];
        [_beanView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_beanView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:timeLine withOffset:10];
        
        _lookNumbersLabel = [UILabel newAutoLayoutView];
        _lookNumbersLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _lookNumbersLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_lookNumbersLabel];
        [_lookNumbersLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_lookNumbersLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _lookButton = [UIButton newAutoLayoutView];
        _lookButton.enabled = NO;
        [_lookButton setTitle:@"查看" forState:(UIControlStateNormal)];
        [_lookButton setTitleColor:UIColorFromRGB(0xa1a1a1) forState:(UIControlStateNormal)];
        _lookButton.titleLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_lookButton];
        [_lookButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_timeLabel];
        [_lookButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:timeLine withOffset:10];
        
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
        
        [matchView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.matchAction?self_weak_.matchAction(self_weak_.dataObj):nil;
        }];
    }
    return self;
}

+(CGFloat)staticHeight
{
    // kLQSPaddingSpecial + 44 + kLQSPaddingLarge + kLQSPaddingLarge + 25 + 20  + [UIFont lqsFontOfSize:20].lineHeight  + 20
    return 156 + [UIFont lqsFontOfSize:20].lineHeight;
}

@end
