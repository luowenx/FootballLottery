//
//  LQAppInitReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAppInitReq.h"

@implementation LQAppInitReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.showReachableJargon = NO;
        self.method = BAHttpRequestTypePost;
        self.limitType = kHTTPRequestLimitTypeDefault;
        self.relativeUrl = @"/api/init";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setBaseAttr(aParameters, t)
    __setObjAttr(aParameters, a)
    __setObjAttr(aParameters, s)
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQAppInitRes *res = [[LQAppInitRes alloc] initWith:aData];
    startParser(res.data, res, LQAppInitRes)
    parserObjAttr(tk)
    parserObjAttr(rk)
    
    return res;
}

@end

@implementation LQAppInitRes

@end
