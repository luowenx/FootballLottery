//
//  LQVersions.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/3/2.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQVersionsReq.h"
#import "AppUtils.h"
#import "LQAppConfiger.h"

@implementation LQVersionsReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = [NSString stringWithFormat:@"/api/versions/%@/%@/%@", @1 , [AppUtils bundleid], [AppUtils bundleVersion]];
    }
    return self;
}


@end

