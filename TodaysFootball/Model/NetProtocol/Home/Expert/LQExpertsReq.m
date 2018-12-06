//
//  LQExpertsReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertsReq.h"

@implementation LQExpertsReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQExpertsRes *res = [[LQExpertsRes alloc] initWith:aData];
    startParser(res.data, res, LQExpertsRes)
    
    if (lqpIsJsonElementValid(intdic, @"expertDetail", NULL)) {
        inobj.expertDetail = intdic[@"expertDetail"];
    }
    
    if (lqpIsJsonElementValid(intdic, @"expertPlanList", NULL)) {
        inobj.expertPlanList = intdic[@"expertPlanList"];
    }
    
    return res;
}

@end

@implementation LQExpertsRes

@end
