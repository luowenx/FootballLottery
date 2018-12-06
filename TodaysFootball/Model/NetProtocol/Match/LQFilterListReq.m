//
//  LQFilterListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQFilterListReq.h"

@implementation LQFilterListReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/matchs/filterList/";
    }
    return self;
}

@end
