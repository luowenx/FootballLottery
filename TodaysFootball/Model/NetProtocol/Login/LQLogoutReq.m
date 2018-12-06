//
//  LQLogoutReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQLogoutReq.h"

@implementation LQLogoutReq

-(instancetype)init
{
    self =[super init];
    if (self) {
        self.relativeUrl = @"/api/users/logout";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

@end
