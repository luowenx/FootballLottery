//
//  LQMatchShowView2.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 比赛视图
 */
@interface LQMatchShowView2 : UIView

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * matchLabel;  // 赛事（欧冠）
@property (nonatomic, strong) UILabel * ranksLeftLabel;   // 左边队伍
@property (nonatomic, strong) UILabel * ranksRightLabel;   // 右边队伍
@property (nonatomic, strong) UILabel * scoreLabel;   // 比分
@property (nonatomic, strong) UIImageView *cornerView;

@property (nonatomic, strong) UILabel * VSLabel;

@end
