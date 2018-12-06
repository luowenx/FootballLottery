//
//  LQInformationListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInformationListReq.h"

@implementation LQInformationListReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedCache = YES;
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = @"/api/news/list";
    }
    return self;
}


-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQInformationListRes *res = [[LQInformationListRes alloc] initWith:aData];

    res.data = aData[@"data"];
    
    return res;
}

@end

@implementation LQInformationListRes
@end

