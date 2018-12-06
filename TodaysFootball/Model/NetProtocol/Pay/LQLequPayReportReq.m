//
//  LQLequPayReportReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/25.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQLequPayReportReq.h"

@implementation LQLequPayReportReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/wallets";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, openId)
}


@end

@implementation LQLequPayReportRes
@end
