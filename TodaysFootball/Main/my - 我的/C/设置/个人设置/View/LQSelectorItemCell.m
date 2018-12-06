//
//  LQSelectorItemCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQSelectorItemCell.h"

@implementation LQSelectorItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        
        _identificationView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_identificationView];
        [_identificationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_identificationView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_identificationView autoSetDimensionsToSize:CGSizeMake(20, 20)];
    }
    return self;
}

@end
