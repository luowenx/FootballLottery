//
//  LQTradeReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQTradeReq.h"

@implementation LQTradeReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/iaporders";
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQTradeRes *res = [[LQTradeRes alloc] initWith:(NSDictionary *)aData];
    startParser(res.data, res, LQTradeRes)
    parserObjAttr(iapOrderId)
    return res;
}

@end

@implementation LQTradeRes

@end
