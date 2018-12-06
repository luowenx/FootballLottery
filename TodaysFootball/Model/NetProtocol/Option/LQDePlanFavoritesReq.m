//
//  LQDePlanFavoritesReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQDePlanFavoritesReq.h"

@implementation LQDePlanFavoritesReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/favorites/";
        self.method = BAHttpRequestTypeDelete;
    }
    return self;
}

@end
