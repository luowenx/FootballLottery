//
//  LQTokenRegster.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQTokenRegster.h"

@implementation LQTokenRegsterReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/reg";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setBaseAttr(aParameters, t)
    __setObjAttr(aParameters, a)
    __setObjAttr(aParameters, s)
    __setObjAttr(aParameters, rk)
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQTokenRegsterRes *res = [[LQTokenRegsterRes alloc] initWith:aData];
    startParser(res.data, res, LQTokenRegsterRes)
    parserObjAttr(rk)
    parserObjAttr(tk)
    
    return res;
}

@end

@implementation LQTokenRegsterRes
@end

