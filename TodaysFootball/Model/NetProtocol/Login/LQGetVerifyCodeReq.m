//
//  LQGetVerifyCodeReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQGetVerifyCodeReq.h"

@implementation LQGetVerifyCodeReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/users/verifycode";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, mobile)
}

@end
