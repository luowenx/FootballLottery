//
//  LQNetResponse.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQNetResponse.h"

@implementation LQNetResponse

-(id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) return nil;
    self = [super init];
    if (!self) return nil;
    
    startParser(dic, self, LQNetResponse)
    parserBaseAttr(ret, integerValue)
    parserObjAttr(msg)
    parserObjAttr(data)
    
    return self;
}


@end
