//
//  LQMatchFollowReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchFollowReq.h"

@implementation LQMatchFollowReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/matchs/followList/";
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQMatchFollowRes *res = [[LQMatchFollowRes alloc] initWith:aData];
    res.matchList = res.data;
    return res;
}

@end

@implementation LQMatchFollowRes@end
