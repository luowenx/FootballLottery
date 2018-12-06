//
//  LQPersonVC.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQTableViewCtrl.h"
/**
 专家详情
 */
@class LQExpertDetail;
@interface LQPersonVC : LQTableViewCtrl
@property(nonatomic,strong)NSNumber *userID;

@property (nonatomic, strong) LQExpertDetail * expertDetail;

@end
