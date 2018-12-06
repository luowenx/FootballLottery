//
//  LQMeCommsReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMeCommsReq.h"

@implementation LQMeCommsReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/news/comments";
    }
    return self;
}


@end

@implementation LQMeCommsRes
@end
