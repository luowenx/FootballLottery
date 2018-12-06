//
//  LQMatchHeaderInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/3/5.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMatchHeaderInfo.h"

@implementation LQMatchHeaderInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {return nil; }
    self = [super init];
    if (self == nil) {return nil; }
    
    startParser(dic, self, LQMatchHeaderInfo)
    parserBaseAttr(homeScore, integerValue)
    parserBaseAttr(isJc, boolValue)
    parserBaseAttr(guestScore, integerValue)
    parserBaseAttr(matchStatus, integerValue)
    parserBaseAttr(hasFollowed, boolValue)
    parserDiffBaseAttr(todaysfootballCategoryId, @"lotteryCategoryId", integerValue)
    parserBaseAttr(matchInfoId, integerValue)
    parserBaseAttr(matchTime, longLongValue)
    parserBaseAttr(threadCount, integerValue)
    
    if (lqpIsJsonElementValid(intdic, @"homeTeam", NULL)) {
        inobj.homeTeam = [[LQTeamInfo alloc] initWith:intdic[@"homeTeam"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"guestTeam", NULL)) {
        inobj.guestTeam = [[LQTeamInfo alloc] initWith:intdic[@"guestTeam"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"leagueMatch", NULL)) {
        inobj.leagueMatch = [[LQLeagueObj alloc] initWith:intdic[@"leagueMatch"]];
    }
    
    if (lqpIsJsonElementValid(intdic, @"webView", NULL)) {
        inobj.webView = intdic[@"webView"];
    }

    
    return self;
}

@end
