//
//  LQMatchDetailObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchDetailObj.h"
#import "LQTeamInfo.h"
#import "LQPlayVoObj.h"

@implementation LQMatchDetailObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQMatchDetailObj)
        parserBaseAttr(leagueId, integerValue)
        parserObjAttr(leagueName)
        parserBaseAttr(matchTime, longLongValue)
        parserBaseAttr(homeScore, integerValue)
        parserBaseAttr(weight, integerValue)
        parserObjAttr(jcNum)
        parserBaseAttr(guestScore, integerValue)
        parserBaseAttr(matchStatus, integerValue)
        parserBaseAttr(guestId, integerValue)
        parserBaseAttr(matchInfoId, integerValue)
        parserObjAttr(betOver)
        parserBaseAttr(focusCount, integerValue)
        parserBaseAttr(threadCount, integerValue)
        parserObjAttr(leagueEnName)
        parserBaseAttr(homeId, integerValue)
        parserBaseAttr(matchCode, integerValue)
        parserBaseAttr(categoryId, integerValue)
        
        if (lqpIsJsonElementValid(intdic, @"playVoList", NULL)) {
            NSMutableArray *playVoList = [NSMutableArray array];
            for (NSDictionary *playVoDic in intdic[@"playVoList"]) {
                [playVoList safeAddObject:[[LQPlayVoObj alloc]initWith:playVoDic]];
            }
            inobj.playVoList = playVoList;
        }
        
        if (lqpIsJsonElementValid(intdic, @"guestTeam", NULL)) {
            inobj.guestTeam = [[LQTeamInfo alloc] initWith:intdic[@"guestTeam"]];
        }
        
        if (lqpIsJsonElementValid(intdic, @"homeTeam", NULL)) {
            inobj.homeTeam = [[LQTeamInfo alloc] initWith:intdic[@"homeTeam"]];
        }
    }
    return self;
}

LQDataTransformationImplementation

@end
