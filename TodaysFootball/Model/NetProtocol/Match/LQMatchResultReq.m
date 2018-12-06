//
//  LQMatchResultReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchResultReq.h"

@implementation LQMatchResultReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/matchs/resultList/";
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQMatchResultRes *res = [[LQMatchResultRes alloc] initWith:aData];
    startParser(res.data, res, LQMatchResultRes)
    parserBaseAttr(matchCount, integerValue)
    if (lqpIsJsonElementValid(intdic, @"matchList", NULL)) {
        inobj.matchList = intdic[@"matchList"];
    }
    return res;
}


@end

@implementation LQMatchResultRes

@end
