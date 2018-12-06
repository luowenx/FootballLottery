//
//  LQPostCommReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQPostCommReq.h"

@implementation LQPostCommReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/news";
    }
    return self;
}

-(void)setDocId:(NSString *)docId
{
    _docId = docId;
    [self apendRelativeUrlWith:[NSString stringWithFormat:@"/%@/comments", docId]];
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, content)
}

@end
