//
//  LQWXLoginReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQWXLoginReq.h"

@implementation LQWXLoginReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/users/wxlogin";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, openid)
    __setObjAttr(aParameters, unionid)
    __setObjAttr(aParameters, nickname)
    __setObjAttr(aParameters, avatar)
    __setObjAttr(aParameters, gender)
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQLoginRes *res = [[LQLoginRes alloc] initWith:aData];
    startParser(res.data, res, LQLoginRes)
    parserObjAttr(nickname)
    parserObjAttr(gender)
    parserObjAttr(avatar)
    parserBaseAttr(state, boolValue)
    parserBaseAttr(colorbean, integerValue)
    parserObjAttr(mobile)

    return res;
}

@end
