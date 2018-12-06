//
//  LQMatchScheduleReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 赛事--全部--赛程 api
 */
@interface LQMatchScheduleReq : LQHttpRequest

@end

@interface LQMatchScheduleRes : LQNetResponse

@property (nonatomic, strong) NSArray * matchList;
@property (nonatomic) NSInteger matchCount;

@end
