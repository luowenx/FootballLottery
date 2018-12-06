//
//  LQGoodsListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQGoodsListReq.h"
#import "AppUtils.h"

@implementation LQGoodsListReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypeGet;
        self.relativeUrl = [NSString stringWithFormat:@"/api/goods/%@", [AppUtils bundleid]];
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQGoodsListRes *res = [[LQGoodsListRes alloc] initWith:aData];
    
    return res;
}

@end

@implementation LQGoodsListRes

@end
