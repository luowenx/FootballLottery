//
//  LQMatchImmediateReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchImmediateReq.h"

@implementation LQMatchImmediateReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/matchs/realTimeList";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQMatchImmediateRes *res = [[LQMatchImmediateRes alloc] initWith:aData];
    startParser(res.data, res, LQMatchImmediateRes)
    parserBaseAttr(matchCount, integerValue)
    
    if (lqpIsJsonElementValid(intdic, @"matchList", NULL)) {
        inobj.matchList = intdic[@"matchList"];
    }
    return res;
}

@end

@implementation LQMatchImmediateRes@end
