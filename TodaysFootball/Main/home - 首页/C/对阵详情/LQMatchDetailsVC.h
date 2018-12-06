//
//  Match details   LQMatchDetailsVC.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"
/**
 比赛详情
 */
@class LQMatchHeaderInfo;
@interface LQMatchDetailsVC : LQBaseViewCtrl

/**
 比赛的id
 */
@property(nonatomic)NSInteger matchID;

/**
 比较详细的比赛数据
 */
@property (nonatomic, strong) LQMatchHeaderInfo *matchInfo;


@end
