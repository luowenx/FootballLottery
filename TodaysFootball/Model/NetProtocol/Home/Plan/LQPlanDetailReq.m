//
//  LQPlanDetailReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPlanDetailReq.h"

@implementation LQPlanDetailReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/plans/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

@end

@implementation LQPlanDetailRes

@end
