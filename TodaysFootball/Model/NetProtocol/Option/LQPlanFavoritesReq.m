//
//  LQPlanFavoritesReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPlanFavoritesReq.h"

@implementation LQPlanFavoritesReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/favorites";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, threadId)
}

@end
