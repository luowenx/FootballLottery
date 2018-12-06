//
//  LQFollowExpert.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFollowExpert.h"

@implementation LQFollowExpert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/followList";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, expertUserId)
}

@end
