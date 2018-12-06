//
//  RecommendExpertObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "RecommendExpertObj.h"

@implementation RecommendExpertObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, RecommendExpertObj)
        parserBaseAttr(cId, integerValue)
        
        if (lqpIsJsonElementValid(intdic, @"expertList", NULL)) {
            NSMutableArray *expertList = [NSMutableArray array];
            for (NSDictionary *expertDic in intdic[@"expertList"]) {
                [expertList safeAddObject:[[LQBaseExpertInfo alloc] initWith:expertDic]];
            }
            inobj.expertList = expertList;
        }
    }
    return self;
}

@end

