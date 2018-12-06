//
//  MatchDetailsTopV.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 比赛详情  xib (已经修改过了)
 */
@interface MatchDetailsTopV : UIView
@property (weak, nonatomic) IBOutlet UIImageView *leftIma;
@property (weak, nonatomic) IBOutlet UIImageView *rightIma;
@property (weak, nonatomic) IBOutlet UILabel *programmeNumL;
@property (weak, nonatomic) IBOutlet UILabel *leftNameL;
@property (weak, nonatomic) IBOutlet UILabel *rightNameL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *VSLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followTopCons;

/**
 查看主场队伍信息
 */
@property (nonatomic, copy) void (^lookHomeTeam)(void);

/**
 查看客场队伍信息
 */
@property (nonatomic, copy) void (^lookguestTeam)(void);

+(instancetype)matchTop;

@end
