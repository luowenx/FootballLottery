//
//  LQExpertsReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 专家详情
 */
@interface LQExpertsReq : LQHttpRequest

@end

@interface LQExpertsRes : LQNetResponse

@property (nonatomic, strong) NSDictionary * expertDetail;

@property (nonatomic, strong) NSArray * expertPlanList;

@end
