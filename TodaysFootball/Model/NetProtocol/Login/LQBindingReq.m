//
//  LQBindingReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBindingReq.h"

@implementation LQBindingReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/users/mobile";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, mobile)
    __setObjAttr(aParameters, verifycode)
}

@end
