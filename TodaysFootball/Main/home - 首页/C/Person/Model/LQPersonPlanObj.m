//
//  LQPersonPlanObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPersonPlanObj.h"
#import "LQMatchObj.h"

@implementation LQPersonPlanObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQPersonPlanObj)
        if (lqpIsJsonElementValid(intdic, @"earliestMatch", NULL)) {
            inobj.earliestMatch = [[LQMatchObj alloc] initWith:intdic[@"earliestMatch"]];
        }
        
        parserObjAttr(hitRateValue)
        parserBaseAttr(isWin, integerValue)
        parserBaseAttr(plock, integerValue)
        parserBaseAttr(price, floatValue)
        parserBaseAttr(publishTime, longLongValue)
        parserBaseAttr(purchased, integerValue)
        parserObjAttr(score)
        parserBaseAttr(showType, integerValue)
        parserBaseAttr(threadId, integerValue)
        parserObjAttr(title)
        parserBaseAttr(views, integerValue)
    }
    return self;
}

+(NSArray *)objArrayWithDics:(NSArray<NSDictionary *> *)dics
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:dics.count];
    
    for (NSDictionary *dic in dics) {
        [array safeAddObject:[[self alloc] initWith:dic]];
    }
    
    return array.copy;
}

@end
