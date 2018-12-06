//
//  LQAllTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAllTableViewCell.h"

@implementation LQAllTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _avatarImageView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        UIView *contentView = [UIView newAutoLayoutView];
        [self.contentView addSubview:contentView];
        [contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [contentView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarImageView withOffset:10];
        
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.textColor = UIColorFromRGB(0x404040);
        _nameLabel.font = [UIFont lqsFontOfSize:32];
        [contentView addSubview:_nameLabel];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _sloganLabel = [UILabel newAutoLayoutView];
        _sloganLabel.font = [UIFont lqsFontOfSize:22];
        _sloganLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [contentView addSubview:_sloganLabel];
        [_sloganLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_sloganLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_sloganLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel withOffset:10];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [contentView addSubview:line];
        [line autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_sloganLabel];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_sloganLabel withOffset:7.5];
        [line autoSetDimensionsToSize:CGSizeMake(.5, 8)];
        _subTitleLine = line;
        
        _hitRollLabel = [UILabel newAutoLayoutView];
        _hitRollLabel.textColor = [UIColor flsMainColor];
        _hitRollLabel.font = [UIFont lqsFontOfSize:22];
        [contentView addSubview:_hitRollLabel];
        [_hitRollLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_sloganLabel];
        NSLayoutConstraint * consRollLeft = [_hitRollLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line withOffset:7.5];
        [_hitRollLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        _followButton = [UIButton newAutoLayoutView];
        _followButton.titleLabel.font = [UIFont lqsFontOfSize:28];
        [_followButton setBackgroundColor:[UIColor flsMainColor]];
        [_followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_followButton roundedRectWith:5];
        [self.contentView addSubview:_followButton];
        [_followButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_followButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_followButton autoSetDimensionsToSize:CGSizeMake(64, 28)];
        
        {
            UIView *line = [UIView newAutoLayoutView];
            line.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [self.contentView addSubview:line];
            [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [line autoSetDimension:ALDimensionHeight toSize:1];
        }
        
        @weakify(self)
        [[_followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.follow?self_weak_.follow(self_weak_.dataObj, (UIButton *)x):nil;
        }];
        
        [RACObserve(self, sloganIsWelt) subscribeNext:^(id x) {
            if ([x boolValue]) {
                consRollLeft.constant = -7.5;
            }else{
                consRollLeft.constant = 7.5;
            }
        }];
    }
    return self;
}

@end
