//
//  LQInfoCommtsCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInfoCommtsCell.h"

@implementation LQInfoCommtsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _headImageView = [UIImageView newAutoLayoutView];
        [_headImageView roundedRectWith:18];
        [self.contentView addSubview:_headImageView];
        [_headImageView autoSetDimensionsToSize:CGSizeMake(36, 36)];
        [_headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingNormal];
        [_headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        
        _genderImageView = [UIImageView newAutoLayoutView];
        _genderImageView.image = imageWithName(@"Profile_manIcon");
        [self.contentView addSubview:_genderImageView];
        [_genderImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_headImageView withOffset:kLQSPaddingNormal];

        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.text = @"";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = [UIColor orangeColor];
        _nameLabel.font = [UIFont lqsFontOfSize:28];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_headImageView];
        [_nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_genderImageView withOffset:kLQSPaddingSmall];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSMarginMax relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        [_genderImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_nameLabel];
        
        _externButton = [UIButton newAutoLayoutView];
        [_externButton setImage:imageWithName(@"mainCellDing") forState:(UIControlStateNormal)];
        [_externButton setImage:imageWithName(@"mainCellDingClick") forState:(UIControlStateSelected)];
        [self.contentView addSubview:_externButton];
        [_externButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingNormal];
        [_externButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_nameLabel];
        
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.text = @"";
        _timeLabel.font = [UIFont lqsFontOfSize:20];
        _timeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:_timeLabel];
        [_timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_headImageView withOffset:kLQSPaddingNormal];
        [_timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_headImageView];
        
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont lqsFontOfSize:30];
        _contentLabel.text = @"";
        [self.contentView addSubview:_contentLabel];
        [_contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_headImageView withOffset:0];
        [_contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingNormal relation:(NSLayoutRelationGreaterThanOrEqual)];
        [_contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headImageView withOffset:kLQSPaddingNormal];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor flsSpaceLineColor];
        [self.contentView addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    return self;
}

+(CGFloat)staticHeight
{
    return kLQSPaddingNormal +  kLQSPaddingNormal + 30 + kLQSPaddingLarge;
}


@end
