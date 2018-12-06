//
//  LQMeCommsCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMeCommsCell.h"

@implementation LQMeCommsCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.externButton.hidden = YES;
        _infoLabel = [UILabel newAutoLayoutView];
        _infoLabel.backgroundColor = [UIColor flsSpaceLineColor];
        _infoLabel.textColor = [UIColor flsCancelColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont lqsFontOfSize:28];
        [self.contentView addSubview:_infoLabel];
        [_infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.headImageView withOffset:0];
        [_infoLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:kLQSPaddingNormal];
    }
    return self;
}

+(CGFloat)staticHeight
{
    return [super staticHeight] + kLQSPaddingLarge;
}

@end
