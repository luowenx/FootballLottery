//
//  LQExpertFollowReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 专家-关注 api
 */
@interface LQExpertFollowReq : LQHttpRequest

@end

@interface LQExpertFollowRes : LQNetResponse

@property (nonatomic, strong) NSArray * followExpertPlanList;

@property (nonatomic, strong) NSArray * recommendExpertList;

@end
