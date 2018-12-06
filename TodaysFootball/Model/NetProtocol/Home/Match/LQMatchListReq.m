//
//  LQMatchListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchListReq.h"

@implementation LQMatchListReq

-(instancetype)init
{
    self  = [super init];
    if (self) {
        self.relativeUrl = @"/api/matchs/";
        self.method = BAHttpRequestTypeGet;
        self.limitType = kHTTPRequestLimitTypeDefault;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQMatchListRes *res = [[LQMatchListRes alloc] initWith:aData];
    res.aData = (NSArray *)res.data;
    
    return res;
}

@end


@implementation LQMatchListRes

@end
