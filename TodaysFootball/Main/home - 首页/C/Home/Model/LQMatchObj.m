//
//  LQMatchObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchObj.h"

@implementation LQMatchObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQMatchObj)
        parserBaseAttr(categoryId, integerValue)
        parserBaseAttr(guestScore, integerValue)
        parserBaseAttr(homeScore, integerValue)
        parserBaseAttr(leagueId, integerValue)
        parserBaseAttr(matchInfoId, integerValue)
        parserBaseAttr(matchStatus, integerValue)
        parserBaseAttr(matchTime, longLongValue)

        parserObjAttr(guestName)
        parserObjAttr(homeName)
        parserObjAttr(leagueName)
        
        // 热门比赛需要
        parserObjAttr(guestIcon)
        parserObjAttr(homeIcon)
        inobj.matchDate = inobj.matchTime;
    }
    return self;
}

@end

