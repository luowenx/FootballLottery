//
//  LQExpertFollowReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertFollowReq.h"

@implementation LQExpertFollowReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/followList/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQExpertFollowRes *res = [[LQExpertFollowRes alloc] initWith:aData];
    startParser(res.data, res, LQExpertFollowRes)
    if (lqpIsJsonElementValid(intdic, @"followExpertPlanList", NULL)) {
        inobj.followExpertPlanList = intdic[@"followExpertPlanList"];
    }
    
    if (lqpIsJsonElementValid(intdic, @"recommendExpertList", NULL)) {
        inobj.recommendExpertList = intdic[@"recommendExpertList"];
    }
    
    return res;
}

@end

@implementation LQExpertFollowRes@end

