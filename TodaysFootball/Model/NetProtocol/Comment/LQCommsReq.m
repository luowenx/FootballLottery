//
//  LQCommsReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQCommsReq.h"

@implementation LQCommsReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/news/";
    }
    return self;
}

-(void)setDocId:(NSString *)docId
{
    _docId = docId;
    [self apendRelativeUrlWith:[NSString stringWithFormat:@"%@/comments", docId]];
}




@end
@implementation LQCommsRes
@end

