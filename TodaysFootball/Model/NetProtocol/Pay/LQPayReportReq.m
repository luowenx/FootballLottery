//
//  LQPayReportReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPayReportReq.h"

@implementation LQPayReportReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = BAHttpRequestTypePost;
        self.relativeUrl = @"/api/iaporders/receipt";
    }
    return self;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    __setObjAttr(aParameters, iapOrderId)
    __setObjAttr(aParameters, data)
}

@end
