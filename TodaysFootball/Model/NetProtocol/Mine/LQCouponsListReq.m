//
//  LQCouponsListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCouponsListReq.h"

@implementation LQCouponsListReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/coupons/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

@end
