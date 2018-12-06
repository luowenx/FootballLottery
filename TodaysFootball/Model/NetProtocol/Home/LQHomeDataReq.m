//
//  LQHomeDataReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHomeDataReq.h"

@implementation LQHomeDataReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/index/v1";
        self.isNeedCache = YES;
    }
    return self;
}

@end
