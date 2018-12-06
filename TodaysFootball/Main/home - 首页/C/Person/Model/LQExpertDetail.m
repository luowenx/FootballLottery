//
//  LQExpertDetail.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertDetail.h"

@implementation LQExpertDetail

-(id)initWith:(NSDictionary *)dic
{
    self = [super initWith:dic];
    if (self) {
        startParser(dic, self, LQExpertDetail)
        parserBaseAttr(conWin, integerValue)
        parserObjAttr(descLink)
        parserDiffObjAttr(aDescription, @"description")
        parserBaseAttr(follower, integerValue)
        parserBaseAttr(hasFollowed, integerValue)
        parserBaseAttr(region, integerValue)
        
        if (lqpIsJsonElementValid(intdic, @"beGoodAtLeague", NULL)) {
            inobj.beGoodAtLeague = intdic[@"beGoodAtLeague"];
        }
        
        if (lqpIsJsonElementValid(intdic, @"leagueMatchStats", NULL)) {
            inobj.leagueMatchStats = intdic[@"leagueMatchStats"];
        }
    }
    return self;
}

LQDataTransformationImplementation

@end
