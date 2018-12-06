//
//  LQMatchShowView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *     显示比赛视图
 *    队伍     头像      VS      头像      队伍
 */
@interface LQMatchShowView : UIView

@property (nonatomic, strong) UILabel * VSLabel;
@property (nonatomic, strong) UILabel * homeNameLabel;
@property (nonatomic, strong) LQAvatarView * homeIconView;
@property (nonatomic, strong) LQAvatarView * guestIconView;
@property (nonatomic, strong) UILabel * guestNameLabel;

@end
