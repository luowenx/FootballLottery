//
//  LQInfomationFavoritesReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInfomationFavoritesReq.h"

@implementation LQInfomationFavoritesReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/news/favorites";
    }
    return self;
}



@end
