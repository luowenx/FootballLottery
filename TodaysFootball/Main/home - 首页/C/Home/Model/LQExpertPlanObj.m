//
//  LQExpertPlanObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertPlanObj.h"
#import "LQMatchObj.h"
#import "ExpertObj.h"

@implementation LQExpertPlanObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic)  return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQExpertPlanObj)
        
        if (lqpIsJsonElementValid(intdic, @"earliestMatch", NULL)) {
            inobj.earliestMatch = [[LQMatchObj alloc] initWith:dic[@"earliestMatch"]];
        }
        if (lqpIsJsonElementValid(intdic, @"expert", NULL)) {
            inobj.expert = [[ExpertObj alloc] initWith:dic[@"expert"]];
        }
        
        parserBaseAttr(plock, integerValue)
        parserBaseAttr(price, floatValue)
        parserBaseAttr(publishTime, longLongValue)
        parserBaseAttr(purchased, integerValue)
        parserObjAttr(score)
        parserBaseAttr(showType, integerValue)
        parserBaseAttr(threadId, integerValue)
        parserBaseAttr(weight, integerValue)
        parserObjAttr(threadTitle)
        
        parserObjAttr(createTimeStr)
        parserBaseAttr(hasThread, boolValue)
        parserBaseAttr(isWin, boolValue)
        parserBaseAttr(views, integerValue)
        
        parserBaseAttr(favoriteTime, longLongValue)
        parserObjAttr(title)
        parserObjAttr(hitRateValue)
    }
    return self;
}

LQDataTransformationImplementation

@end
