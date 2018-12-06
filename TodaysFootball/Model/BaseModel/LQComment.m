//
//  LQComment.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQComment.h"

@implementation LQComment

- (id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) { return nil; }
    self = [super init];
    if (!self) {return nil; }
    
    startParser(dic, self, LQComment)
    parserObjAttr(commentTime)
    parserObjAttr(content)
    parserObjAttr(id)
    
    return self;
}

LQDataTransformationImplementation

@end
