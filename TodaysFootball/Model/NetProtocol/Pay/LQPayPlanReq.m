//
//  LQPayPlanReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPayPlanReq.h"

@implementation LQPayPlanReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/orders";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, threadId)
    __setObjAttr(aParameters, couponId)
    __setObjAttr(aParameters, price)
    
}

@end
