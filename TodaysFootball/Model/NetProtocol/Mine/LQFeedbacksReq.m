//
//  LQFeedbacksReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFeedbacksReq.h"

@implementation LQFeedbacksReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/feedbacks";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, content)
}

@end
