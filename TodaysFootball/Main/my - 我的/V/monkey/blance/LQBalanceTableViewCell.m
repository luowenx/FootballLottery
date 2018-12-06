//
//  LQBalanceTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBalanceTableViewCell.h"

@implementation LQBalanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.headIma.layer.cornerRadius = 21.5;
    self.headIma.layer.masksToBounds = YES;
    
    self.titleL.font = [UIFont lqsFontOfSize:28];
    self.titleL.textColor = UIColorFromRGB(0x393939);
    
    self.timeL.textColor = UIColorFromRGB(0xa3a3a3);
    self.timeL.font = [UIFont lqsFontOfSize:20];
    
    self.priceLabel.font = [UIFont lqsFontOfSize:30 isBold:YES];
    self.priceLabel.textColor = [UIColor flsMainColor];
    
    _typeLabel = [UILabel newAutoLayoutView];
    _typeLabel.font = [UIFont lqsFontOfSize:30];
    [self.headIma addSubview:_typeLabel];
    [_typeLabel autoCenterInSuperview];
    
    UIView *footer = [UIView newAutoLayoutView];
    [self.contentView addSubview:footer];
    footer.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [footer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [footer autoSetDimension:ALDimensionHeight toSize:3];
}




@end
