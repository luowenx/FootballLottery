//
//  LQDetailsTopV.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQDetailsTopV.h"

@implementation LQDetailsTopV

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleL.font = [UIFont lqsFontOfSize:32];
    self.titleL.textColor =UIColorFromRGB(0x393939);
    
    self.timeL.font =[UIFont lqsFontOfSize:20];
    self.timeL.textColor = UIColorFromRGB(0xa2a2a2);
    
    [self.headIma setCornerRadius:22 borderColor:UIColorFromRGB(0xb2b2b2) borderWidth:.5];
    self.nameL.textColor = UIColorFromRGB(0x393939);
    self.nameL.font = [UIFont lqsFontOfSize:34];
    
    self.cardL.textColor = UIColorFromRGB(0xa2a2a2);
    self.cardL.font = [UIFont lqsFontOfSize:22];
    
    [self.followBtn roundedRectWith:5];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.followBtn.titleLabel.font = [UIFont lqsFontOfSize:28];
    
    [self.followBtn setTitle:@"+  关注" forState:UIControlStateNormal];
    [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    
    self.hitStatusBtn.titleLabel.font = [UIFont lqsFontOfSize:24];
    [self.hitStatusBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.hitStatusBtn setTitle:@"红" forState:(UIControlStateNormal)];
    [self.hitStatusBtn setTitle:@"黑" forState:(UIControlStateSelected)];

    [self.hitStatusBtn setBackgroundImage:imageWithName(@"红") forState:(UIControlStateNormal)];
    [self.hitStatusBtn setBackgroundImage:imageWithName(@"黑") forState:(UIControlStateSelected)];
    
    _line.backgroundColor = [UIColor flsSpaceLineColor];
}

@end
