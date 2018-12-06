//
//  LQExpertPopularityReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertPopularityReq.h"

@implementation LQExpertPopularityReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/popularity";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

@end
