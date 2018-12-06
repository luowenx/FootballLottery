//
//  LQDeleteExpert.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQDeleteExpert.h"

@implementation LQDeleteExpert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/experts/followList/";
        self.method = BAHttpRequestTypeDelete;
    }
    return self;
}

@end
