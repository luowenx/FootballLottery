//
//  LQUpdateUserReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQUpdateUserReq.h"

@implementation LQUpdateUserReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/users";
        self.method = BAHttpRequestTypePost;
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, nickname)
    __setObjAttr(aParameters, gender)
    __setObjAttr(aParameters, avatar)
}

@end
