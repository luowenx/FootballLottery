//
//  LQMatchDetailsStatusViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"

/**
 xxx 比赛详情
 */
@class LQMatchHeaderInfo;
@interface LQMatchDetailsStatusViewCtrl : LQBaseViewCtrl

/**
 比赛的id
 */
@property(nonatomic)NSInteger matchID;

/**
 比较详细的比赛数据
 */
@property (nonatomic, strong) LQMatchHeaderInfo *matchInfo;


@end
