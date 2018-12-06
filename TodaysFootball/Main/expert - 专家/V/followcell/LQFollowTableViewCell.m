//
//  LQFollowTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFollowTableViewCell.h"

@implementation LQFollowTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.straightLabel.hidden = YES;
        self.hitRateLabel.hidden = YES;
        self.hitDesLabel.hidden = YES;
        self.cornerView.hidden = YES;
        self.signView.hidden = YES;
    }
    return self;
}

@end
