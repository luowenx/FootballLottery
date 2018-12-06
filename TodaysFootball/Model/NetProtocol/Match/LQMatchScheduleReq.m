//
//  LQMatchScheduleReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchScheduleReq.h"

@implementation LQMatchScheduleReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/matchs/scheduleList/";
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQMatchScheduleRes *res = [[LQMatchScheduleRes alloc] initWith:aData];
    startParser(res.data, res, LQMatchScheduleRes)
    parserBaseAttr(matchCount, integerValue)
    
    if (lqpIsJsonElementValid(intdic, @"matchList", NULL)) {
        inobj.matchList = intdic[@"matchList"];
    }
    return res;
}

@end

@implementation LQMatchScheduleRes

@end
