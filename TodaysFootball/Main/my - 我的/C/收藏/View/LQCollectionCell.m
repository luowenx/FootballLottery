//
//  LQCollectionCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCollectionCell.h"
#import "LQMatchShowView2.h"
#import "LQBeanView.h"

@implementation LQCollectionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _avatarView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_avatarView];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [_avatarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingSpecial];
        
        UIView *userView = [UIView newAutoLayoutView];
        [self.contentView addSubview:userView];
        [userView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarView withOffset:10];
        [userView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_avatarView];
        
        _nameLable = [UILabel newAutoLayoutView];
        _nameLable.font = [UIFont lqsFontOfSize:32];
        _nameLable.textColor = UIColorFromRGB(0x404040);
        [userView addSubview:_nameLable];
        [_nameLable autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_nameLable autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_nameLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        _sloganLabel = [UILabel newAutoLayoutView];
        _sloganLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _sloganLabel.font = [UIFont lqsFontOfSize:22];
        _sloganLabel.text = @"";
        [userView addSubview:_sloganLabel];
        [_sloganLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_sloganLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_sloganLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        [_sloganLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLable withOffset:8];
        
        _beanView = [LQBeanView newAutoLayoutView];
        [self.contentView addSubview:_beanView];
        [_beanView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        [_beanView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_nameLable];
        
        _payTimeLabel = [UILabel newAutoLayoutView];
        _payTimeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _payTimeLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_payTimeLabel];
        [_payTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        [_payTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_sloganLabel];
        
        _collectionLabel = [UILabel newAutoLayoutView];
        _collectionLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _collectionLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_collectionLabel];
        [_collectionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        [_collectionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_nameLable];
        
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
        
        _matchView = [LQMatchShowView2 newAutoLayoutView];
        _matchView.bgView.backgroundColor = [UIColor clearColor];
        _matchView.cornerView.hidden = YES;
        [self.contentView addSubview:_matchView];
        [_matchView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_matchView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_matchView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView withOffset:kLQSPaddingLarge];
        
        _publishTimeLabel = [UILabel newAutoLayoutView];
        _publishTimeLabel.font = [UIFont lqsFontOfSize:20];
        _publishTimeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_publishTimeLabel];
        [_publishTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
//        [_publishTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSPaddingHuge];
        
        {
            UIView *line = [UIView newAutoLayoutView];
            line.backgroundColor = [UIColor flsSpaceLineColor];
            [self.contentView addSubview:line];
            [line autoSetDimensionsToSize:CGSizeMake(.5, 10)];
            [line autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
            [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_publishTimeLabel withOffset:10];
        }
        
        _priceBeanView = [LQBeanView newAutoLayoutView];
        [self.contentView addSubview:_priceBeanView];
        [_priceBeanView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_publishTimeLabel withOffset:20];
        [_priceBeanView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        
        _lookLabel = [UILabel newAutoLayoutView];
        _lookLabel.text = @"查看";
        _lookLabel.font = [UIFont lqsFontOfSize:20];
        _lookLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_lookLabel];
        [_lookLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_publishTimeLabel withOffset:20];
        [_lookLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        
        _lookNumbersLabel = [UILabel newAutoLayoutView];
        _lookNumbersLabel.font = [UIFont lqsFontOfSize:20];
        _lookNumbersLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_lookNumbersLabel];
        [_lookNumbersLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_lookNumbersLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        
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
        [_hitRollBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        [_hitRollBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSPaddingHuge + 8];
        
        _matchStatusLabel = [UILabel newAutoLayoutView];
        _matchStatusLabel.textColor = [UIColor whiteColor];
        _matchStatusLabel.font = [UIFont lqsFontOfSize:20];
        [_matchStatusLabel roundedRectWith:3];
        [self.contentView addSubview:_matchStatusLabel];
        [_matchStatusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_matchStatusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        
        _hitRollLabel = [UILabel newAutoLayoutView];
        _hitRollLabel.textColor = UIColorFromRGB(0xa7a7a7);
        _hitRollLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_hitRollLabel];
        [_hitRollLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_hitRollBtn withOffset:-5];
        [_hitRollLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_publishTimeLabel];
        
        {
            UIView *line = [UIView newAutoLayoutView];
            line.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [self.contentView addSubview:line];
            [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [line autoSetDimension:ALDimensionHeight toSize:8];
        }
        
        @weakify(self)
        [_avatarView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.lookExpert?self_weak_.lookExpert(self_weak_.dataObj):nil;
        }];
        
        [userView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.lookExpert?self_weak_.lookExpert(self_weak_.dataObj):nil;
        }];
    }
    return self;
}

+(CGFloat)staticHeight
{
    // 17 + 44 + 15 + 15 + + 25 + 20 + 20 + 20 + 8
    return 176;
}

@end
