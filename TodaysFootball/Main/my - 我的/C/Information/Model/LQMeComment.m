//
//  LQMeComment.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMeComment.h"

@implementation LQMeComment

- (id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) { return nil; }
    self = [super initWith:dic];
    if (!self) {return nil; }
    
    if (lqpIsJsonElementValid(dic, @"doc", NULL)) {
        self.doc = [[LQInformation alloc] initWith:dic[@"doc"]];
    }
    
    return self;
}

LQDataTransformationImplementation

@end
