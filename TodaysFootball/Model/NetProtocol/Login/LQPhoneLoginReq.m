//
//  LQPhoneLoginReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPhoneLoginReq.h"

@implementation LQPhoneLoginReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/users/login";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, mobile)
    __setObjAttr(aParameters, pwd)
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
