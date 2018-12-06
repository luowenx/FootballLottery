//
//  LQSiftOutVC.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"

/**
 赛选
 */
@class LQFilterConfiger;
@interface LQSiftOutVC : LQBaseViewCtrl

/**
 赛选初始对象
 */
@property (nonatomic, strong) LQFilterConfiger *configer;

/**
 赛选回调
 */
@property (nonatomic, copy) void (^confirmFilter)(LQFilterConfiger *configer);


@end
