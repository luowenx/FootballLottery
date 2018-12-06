//
//  LQDeleteCommReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQDeleteCommReq.h"

@implementation LQDeleteCommReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeDelete;
        self.relativeUrl = @"/api/news/comments/";
    }
    return self;
}

-(void)setCommId:(NSString *)commId
{
    _commId = commId;
    [self apendRelativeUrlWith:commId];
}

@end
