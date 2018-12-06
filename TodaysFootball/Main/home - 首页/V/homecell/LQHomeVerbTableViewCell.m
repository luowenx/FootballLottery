//
//  LQHomeVerbTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/30.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHomeVerbTableViewCell.h"

@implementation LQHomeVerbTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *contentView = [UIView newAutoLayoutView];
        [self.contentView addSubview:contentView];
        [contentView autoCenterInSuperview];
        [contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:19];
        [contentView autoPinEdgeToSuperviewEdge:ALEdgeTop   withInset:7.5];
        
        _leagueLabel = [UILabel newAutoLayoutView];
        _leagueLabel.font = [UIFont lqsFontOfSize:20];
        _leagueLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [contentView addSubview:_leagueLabel];
        [_leagueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_leagueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        _leagueTimeLabel = [UILabel newAutoLayoutView];
        _leagueTimeLabel.font = [UIFont lqsFontOfSize:20];
        _leagueTimeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [contentView addSubview:_leagueTimeLabel];
        [_leagueTimeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_leagueLabel];
        [_leagueTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leagueLabel withOffset:5];
        
        UIImageView *triangleImageView = [UIImageView newAutoLayoutView];
        triangleImageView.image = imageWithName(@"更多");
        [contentView addSubview:triangleImageView];
        [triangleImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [triangleImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [triangleImageView autoSetDimensionsToSize:CGSizeMake(6, 10)];
        
        _scoreLabel = [UILabel newAutoLayoutView];
        _scoreLabel.font  = [UIFont systemFontOfSize:10];
        _scoreLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [contentView addSubview:_scoreLabel];
        [_scoreLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:triangleImageView];
        [_scoreLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:triangleImageView withOffset:-10];
        
        _VSLabel = [UILabel newAutoLayoutView];
        _VSLabel.text = @"VS";
        [contentView addSubview:_VSLabel];
        [_VSLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_VSLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_leagueLabel];
        [_VSLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _leftTeamImageView = [[LQAvatarView alloc] initWithLength:17 grade:kLQAvatarViewGradeMini];
        [contentView addSubview:_leftTeamImageView];
        [_leftTeamImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_leftTeamImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_VSLabel withOffset:-20];
        
        _leftTeamLabel = [UILabel newAutoLayoutView];
        _leftTeamLabel.textColor = UIColorFromRGB(0x404040);
        _leftTeamLabel.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:_leftTeamLabel];
        [_leftTeamLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_leftTeamLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_leftTeamImageView withOffset:-10];
        
        _rightTeamImageView = [[LQAvatarView alloc] initWithLength:17 grade:kLQAvatarViewGradeMini];
        [contentView addSubview:_rightTeamImageView];
        [_rightTeamImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_rightTeamImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_VSLabel withOffset:20];
        [_rightTeamImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _rightTeamLabel = [UILabel newAutoLayoutView];
        _rightTeamLabel.textColor = UIColorFromRGB(0x404040);
        _rightTeamLabel.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:_rightTeamLabel];
        [_rightTeamLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_VSLabel];
        [_rightTeamLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_rightTeamImageView withOffset:10];
        [_rightTeamLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
    }
    return self;
}

@end
