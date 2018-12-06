//
//  LequLoginInfo.m
//  LequSDK
//
//  Created by 莫 东荣 on 13-4-10.
//  Copyright (c) 2013年 莫 东荣. All rights reserved.
//

#import "LequLoginInfo.h"


@implementation LequLoginInfo
@synthesize openId;
@synthesize token;
@synthesize timestamp;

static LequLoginInfo* instance = nil;

+ (LequLoginInfo *)getInstance
{
    if (instance == nil) {
        instance = [LequLoginInfo alloc];
    }
    
    return instance;
}




@end


