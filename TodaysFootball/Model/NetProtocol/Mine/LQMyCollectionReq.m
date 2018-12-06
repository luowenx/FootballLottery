//
//  LQMyCollectionReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyCollectionReq.h"

@implementation LQMyCollectionReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/favorites/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

@end

