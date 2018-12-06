//
//  LQDeleteFavoriteInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQDeleteFavoriteInfoReq.h"

@implementation LQDeleteFavoriteInfoReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeDelete;
        self.relativeUrl = @"/api/news/favorites/";
    }
    return self;
}

-(void)setDocId:(NSString *)docId
{
    [self apendRelativeUrlWith:docId];
}

@end
