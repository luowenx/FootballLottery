//
//  MatchDetailsTopV.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "MatchDetailsTopV.h"

@implementation MatchDetailsTopV

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backTopCons.constant += (is_iPhoneX?13:0);
    self.followTopCons.constant += (is_iPhoneX?13:0);
    
    [self.leftIma setCornerRadius:35.5 borderColor:UIColorFromRGB(0xd2d2d2) borderWidth:1];
    [self.rightIma setCornerRadius:35.5 borderColor:UIColorFromRGB(0xd2d2d2) borderWidth:1];
        
    [self.followBtn setCornerRadius:4 borderColor:[UIColor whiteColor] borderWidth:1];
    
    [self.followBtn.titleLabel setFont:[UIFont lqsFontOfSize:30]];
    [self.followBtn setTitle:@"+  关注" forState:(UIControlStateNormal)];
    [self.followBtn setTitle:@"已关注" forState:(UIControlStateSelected)];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.followBtn setTitleColor:UIColorFromRGB(0xf2f2f2) forState:(UIControlStateSelected)];
    
    [self.programmeNumL setCornerRadius:3 borderColor:[UIColor whiteColor] borderWidth:.5];
    
    self.VSLabel.font = [UIFont lqsBEBASFontOfSize:68];
    
    @weakify(self)
    self.leftIma.userInteractionEnabled = YES;
    [self.leftIma addTapGestureWithBlock:^(UIView *gestureView) {
        self_weak_.lookHomeTeam?self_weak_.lookHomeTeam():nil;
    }];
    
    self.rightIma.userInteractionEnabled = YES;
    [self.rightIma addTapGestureWithBlock:^(UIView *gestureView) {
        self_weak_.lookguestTeam?self_weak_.lookguestTeam():nil;
    }];
}

+(instancetype)matchTop
{
    MatchDetailsTopV *matchTop = [[[NSBundle mainBundle] loadNibNamed:@"MatchDetailsTopV" owner:self options:nil] lastObject];
    return matchTop;
}

@end
