//
//  LQMatchImmediateReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 赛事--全部--即时 api
 */
@interface LQMatchImmediateReq : LQHttpRequest

@end

@interface LQMatchImmediateRes : LQNetResponse

@property (nonatomic, strong) NSArray * matchList;
@property (nonatomic) NSInteger matchCount;

@end
/*
 [0]    (null)    @"matchList" : @"10 elements"
 [1]    (null)    @"matchCount" : (long)10
 */
