//
//  LQMatchListInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchListInfo.h"
#import "ExpertObj.h"

@implementation LQMatchListInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic)return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQMatchListInfo)
        
        if (lqpIsJsonElementValid(intdic, @"expert", NULL)) {
            inobj.expert = [[ExpertObj alloc] initWith:intdic[@"expert"]];
        }
        parserBaseAttr(threadId, integerValue)
        parserBaseAttr(publishTime, longLongValue)
        parserBaseAttr(purchased, integerValue)
        parserBaseAttr(price, floatValue)
        parserBaseAttr(isWin, integerValue)
        parserBaseAttr(weight, integerValue)
        parserObjAttr(threadTitle)
        parserBaseAttr(plock, integerValue)
        parserBaseAttr(showType, integerValue)
        parserBaseAttr(views, integerValue)
    }
    return self;
}

LQDataTransformationImplementation

@end
