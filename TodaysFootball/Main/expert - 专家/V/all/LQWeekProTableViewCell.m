//
//  LQWeekProTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQWeekProTableViewCell.h"

@interface LQWeekProTableViewCell ()

@property (nonatomic, strong) UIButton * rankButton;

@end

@implementation LQWeekProTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _rankButton = [UIButton newAutoLayoutView];
        [_rankButton setTitleColor:UIColorFromRGB(0x404040) forState:(UIControlStateNormal)];
        _rankButton.titleLabel.font = [UIFont lqsFontOfSize:22];
        [self.contentView addSubview:_rankButton];
        [_rankButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_rankButton autoSetDimension:ALDimensionWidth toSize:44];
        [_rankButton autoSetDimension:ALDimensionHeight toSize:25];
        
        _avatarImageView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:45];
        
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
        
        _followButton = [UIButton newAutoLayoutView];
        _followButton.titleLabel.font = [UIFont lqsFontOfSize:28];
        [_followButton setBackgroundColor:[UIColor flsMainColor]];
        [_followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_followButton roundedRectWith:5];
        [self.contentView addSubview:_followButton];
        [_followButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_followButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_followButton autoSetDimensionsToSize:CGSizeMake(64, 28)];
        
        _extensionIImageView = [UIImageView newAutoLayoutView];
        _extensionIImageView.image = imageWithName(@"百分比");
        [self.contentView addSubview:_extensionIImageView];
        [_extensionIImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_followButton];
        [_extensionIImageView autoSetDimensionsToSize:CGSizeMake(8, 8)];
//        [_extensionIImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_followButton withOffset:-18];
        [_extensionIImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        
        _extensionLabel = [UILabel newAutoLayoutView];
        _extensionLabel.textColor = [UIColor flsMainColor];
        _extensionLabel.font = [UIFont lqsBEBASFontOfSize:60];
        [self.contentView addSubview:_extensionLabel];
        [_extensionLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_extensionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_extensionIImageView];
        
        {
            UIView *line = [UIView newAutoLayoutView];
            line.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [self.contentView addSubview:line];
            [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [line autoSetDimension:ALDimensionHeight toSize:1];
        }
        
        @weakify(self)
        [[_followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.follow?self_weak_.follow(self_weak_.dataObj):nil;
        }];
    }
    return self;
}

-(void)setRank:(NSInteger)rank
{
    _rank = rank;
    [_rankButton setTitle:nil forState:(UIControlStateNormal)];
    [_rankButton setImage:nil forState:UIControlStateNormal];
    switch (rank) {
        case 1:{
            [_rankButton setImage:imageWithName(@"画板 4") forState:UIControlStateNormal];
            break;
        }
        case 2:{
            [_rankButton setImage:imageWithName(@"画板 3") forState:UIControlStateNormal];
            break;
        }
        case 3:{
            [_rankButton setImage:imageWithName(@"画板 5") forState:UIControlStateNormal];
            break;
        }
        default:{
            [_rankButton setTitle:@(rank).stringValue forState:(UIControlStateNormal)];
        }
            break;
    }
}

@end
