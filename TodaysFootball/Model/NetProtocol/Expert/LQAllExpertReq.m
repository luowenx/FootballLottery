//
//  LQAllExpertReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAllExpertReq.h"

@implementation LQAllExpertReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/list/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQAllExpertRes *res = [[LQAllExpertRes alloc] initWith:(NSDictionary *)aData];
    res.expers = res.data;
    return res;
}

@end

@implementation LQAllExpertRes

@end
