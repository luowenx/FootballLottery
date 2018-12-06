//
//  LQComment.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInfoComment.h"

@implementation LQInfoComment

- (id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) { return nil; }
    self = [super initWith:dic];
    if (!self) {return nil; }
    
    if (lqpIsJsonElementValid(dic, @"user", NULL)) {
        self.user = [[LQUserInfo alloc] initWith:dic[@"user"]];
    }

    return self;
}

LQDataTransformationImplementation

@end
