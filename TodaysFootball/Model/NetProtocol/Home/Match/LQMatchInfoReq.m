//
//  LQMatchInfoReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchInfoReq.h"


@implementation LQMatchInfoReq

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/matchs/";
    }
    return self;
}

@end

