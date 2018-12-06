//
//  LQMacthShowObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMacthShowObj.h"
#import "LQTeamInfo.h"

@implementation LQMacthShowObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (!self)  return nil;
    startParser(dic, self, LQMacthShowObj)
    if (lqpIsJsonElementValid(intdic, @"play", NULL)) {
        inobj.play = [[LQplayObj alloc] initWith:intdic[@"play"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"homeTeam", NULL)) {
        inobj.homeTeam = [[LQTeamInfo alloc] initWith:intdic[@"homeTeam"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"leagueMatch", NULL)) {
        inobj.leagueMatch = [[LQMatchInfo alloc] initWith:intdic[@"leagueMatch"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"guestTeam", NULL)) {
        inobj.guestTeam = [[LQTeamInfo alloc] initWith:intdic[@"guestTeam"]];
    }
    
    parserBaseAttr(threadCount, integerValue)
    parserBaseAttr(homeScore, integerValue)
    parserBaseAttr(guestScore, integerValue)
    parserBaseAttr(matchStatus, integerValue)
    parserBaseAttr(favPushStatus, integerValue)
    parserBaseAttr(time, longLongValue)
    parserDiffBaseAttr(todaysfootballCategoryId, @"lotteryCategoryId", integerValue)
    parserBaseAttr(matchInfoId, integerValue)
    parserBaseAttr(matchTime, longLongValue)
    parserBaseAttr(hasFilterOdds, integerValue)
    parserBaseAttr(hasLive, integerValue)
    
    /************* 组装 运行时属性 ***************/
    inobj.recordString = @"";
    for (LQplayInfo *__playInfo in inobj.play.playItemList) {
        NSString *apendStr = [NSString stringWithFormat:@"  %@%.2f", __playInfo.playItemName, __playInfo.odds];
        inobj.recordString = [inobj.recordString stringByAppendingString:apendStr];
    }
    
    if (lqpIsJsonElementValid(intdic, @"matchTime", NULL)) {
        inobj.matchDate = [NSString stringFormatIntervalSince1970_MonthDay_Slash:inobj.matchTime];
    }
    
    return self;
}

LQDataTransformationImplementation

@end

@implementation LQplayObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (!self)  return nil;
    startParser(dic, self, LQplayObj)
    parserObjAttr(playCode)
    parserBaseAttr(playId, integerValue)
    parserObjAttr(concede)
    if (lqpIsJsonElementValid(intdic, @"playItemList", NULL)) {
        inobj.playItemList = [LQplayInfo objArrayWithDics:intdic[@"playItemList"]];
    }
    return self;
}

@end

@implementation LQMatchInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (!self)  return nil;
    startParser(dic, self, LQMatchInfo)
    parserBaseAttr(leagueId, integerValue)
    parserObjAttr(leagueName)
    
    return self;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __setObjAttr(dic, self.leagueName)
    __setBaseAttrInsist(dic, self.leagueId)
    return dic.copy;
}

@end

@implementation LQplayInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (!self)  return nil;
    startParser(dic, self, LQplayInfo)
    parserObjAttr(playItemCode)
    parserBaseAttr(odds, doubleValue)
    parserBaseAttr(playItemId, integerValue)
    parserObjAttr(playItemName)
    return self;
}

LQDataTransformationImplementation

@end
