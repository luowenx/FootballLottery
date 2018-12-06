//
//  LQFollowMatchReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFollowMatchReq.h"

@implementation LQFollowMatchReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/matchs/followList";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, matchInfoId)
}

@end
