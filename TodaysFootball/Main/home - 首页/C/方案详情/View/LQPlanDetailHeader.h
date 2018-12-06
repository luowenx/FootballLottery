//
//  LQPlanDetailHeader.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/12.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LQPlanDetailShowType) {
    LQPlanDetailShowTypeUnknown,
    LQPlanDetailShowTypeShowContent,  // showContent
    LQPlanDetailShowTypeCountdown,  // 比赛未开始、显示倒计时
    LQPlanDetailShowTypeBeginTips,   // 比赛开始的提示
    LQPlanDetailShowTypeUnderway,    // 比赛正在进行
};

