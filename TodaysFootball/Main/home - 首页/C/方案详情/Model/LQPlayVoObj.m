//
//  LQPlayVoObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPlayVoObj.h"

@implementation LQPlayVoObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self ) {
        startParser(dic, self, LQPlayVoObj)
        parserBaseAttr(playId, integerValue)
        parserObjAttr(extraOddsDesc)
        parserObjAttr(playCode)
        parserObjAttr(playName)
        parserObjAttr(concede)
        
        if (lqpIsJsonElementValid(intdic, @"itemVoList", NULL)) {
            NSMutableArray  *itemVoList = [NSMutableArray array];
            for (NSDictionary *itemVoDic in intdic[@"itemVoList"]) {
                [itemVoList safeAddObject:[[LQItemVo alloc]initWith:itemVoDic]];
            }
            inobj.itemVoList = itemVoList;
        }
        
        if (lqpIsJsonElementValid(intdic, @"extraOddsList", NULL)) {
            NSMutableArray *extraOddsList = [NSMutableArray array];
            for (NSDictionary *extraOddsDic in intdic[@"extraOddsList"]) {
                [extraOddsList safeAddObject:[[LQExtraOdds alloc]initWith:extraOddsDic]];
            }
            inobj.extraOddsList = extraOddsList;
        }
        
    }
    return  self;
}


@end

@implementation LQItemVo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self ) {
        startParser(dic, self, LQItemVo)
        parserObjAttr(playItemName)
        parserBaseAttr(isMRecommend, integerValue)
        parserBaseAttr(isRecommend, integerValue)
        parserBaseAttr(isMatchResult, integerValue)
        parserBaseAttr(odds, doubleValue)
        parserBaseAttr(playItemId, integerValue)
        parserObjAttr(playItemCode)
        parserDiffBaseAttr(extention_id, @"id", integerValue)
    }
    return  self;
}

@end

@implementation LQExtraOdds

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self ) {
        startParser(dic, self, LQExtraOdds)
        parserObjAttr(currentConcedeScore)
        parserObjAttr(oddsCompany)
        parserObjAttr(originConcedeScore)
        if (lqpIsJsonElementValid(intdic, @"itemOddsList", NULL)) {
            NSMutableArray *itemOddsList = [NSMutableArray array];
            for (NSDictionary *itemOddsDic in intdic[@"itemOddsList"]) {
                [itemOddsList safeAddObject:[[LQItemOdds alloc]initWith:itemOddsDic]];
            }
            inobj.itemOddsList = itemOddsList;
        }
    }
    return  self;
}

@end

@implementation LQItemOdds

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQItemOdds)
        parserBaseAttr(originOdds, doubleValue)
        parserBaseAttr(currentOdds, doubleValue)
        parserObjAttr(currentOddsChange)
    }
    return self;
}

@end
