//
//  LQLeagueObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQLeagueObj.h"

@implementation LQLeagueObj

LQDataTransformationImplementation

-(id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {return nil;}
    if (self = [super init]) {
        startParser(dic, self, LQLeagueObj)
        parserObjAttr(leagueName)
        parserBaseAttr(leagueId, integerValue)
    }
    return self;
}

-(BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[LQLeagueObj class]]) {
        return NO;
    }
    LQLeagueObj *obj = (LQLeagueObj *)object;
    if (obj.leagueId == self.leagueId) {
        return YES;
    }
    return [super isEqual:object];
}

@end
