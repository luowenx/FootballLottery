//
//  LQPerSetupTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPerSetupTableViewCell.h"

@interface LQPerSetupTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *line;


@end

@implementation LQPerSetupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.headIma roundedRectWith:22];
    self.titleL.font = [UIFont lqsFontOfSize:30];
    self.titleL.textColor = UIColorFromRGB(0x404040);
    self.titleL.textAlignment = NSTextAlignmentLeft;
    self.messL.font = [UIFont lqsFontOfSize:30];
    self.messL.textColor = UIColorFromRGB(0x404040);
    self.messL.textAlignment = NSTextAlignmentRight;
    self.line.backgroundColor = UIColorFromRGB(0xf2f2f2);

}


@end
