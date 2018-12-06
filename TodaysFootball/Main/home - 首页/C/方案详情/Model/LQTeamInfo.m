//
//  LQTeamInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQTeamInfo.h"

@implementation LQTeamInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQTeamInfo)
        parserObjAttr(teamIcon)
        parserBaseAttr(teamId, integerValue)
        parserObjAttr(teamName)
        parserObjAttr(teamEnName)
        parserDiffBaseAttr(todaysfootballCategoryId, @"lotteryCategoryId", integerValue)
        parserBaseAttr(teamCode, integerValue)
    }
    return self;
}

@end
