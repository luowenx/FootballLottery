//
//  LQMyOrdersReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyOrdersReq.h"

@implementation LQMyOrdersReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/orders/";
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQNetResponse *res = [[LQNetResponse alloc] initWith:(NSDictionary *)aData];
    
    return res;
}

@end
