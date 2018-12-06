//
//  HomeDataObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "HomeDataObj.h"
#import "RecommendExpertObj.h"
#import "LQMatchObj.h"
#import "ExpertObj.h"
#import "LQExpertPlanObj.h"
#import "LQLinkInfo.h"

@implementation HomeDataObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, HomeDataObj)
        parserBaseAttr(freeThreadCount, integerValue)
        parserBaseAttr(followNewThreadCount, integerValue)

        if (lqpIsJsonElementValid(intdic, @"recommendExpertList", NULL)) {
            NSMutableArray *recommendExpertList = [NSMutableArray array];
            for (NSDictionary *recommendExpertDic in intdic[@"recommendExpertList"]) {
                [recommendExpertList safeAddObject:[[RecommendExpertObj alloc]initWith:recommendExpertDic]];
            }
            inobj.recommendExpertList = recommendExpertList;
        }
        
        if (lqpIsJsonElementValid(intdic, @"selectExpertPlanList", NULL)) {
            NSMutableArray *selectExpertPlanList  = [NSMutableArray array];
            for (NSDictionary *expertPlanDic in intdic[@"selectExpertPlanList"]) {
                [selectExpertPlanList safeAddObject:[[LQExpertPlanObj alloc]initWith:expertPlanDic]];
            }
            inobj.selectExpertPlanList = selectExpertPlanList;
        }
        
        if (lqpIsJsonElementValid(intdic, @"headList", NULL)) {
            NSMutableArray *headList = [NSMutableArray array];
            for (NSDictionary *headDic in intdic[@"headList"]) {
                [headList safeAddObject:[[LQLinkInfo alloc]initWith:headDic]];
            }
            inobj.headList = headList;
        }
        
        if (lqpIsJsonElementValid(intdic, @"hotMatchList", NULL)) {
            NSMutableArray *hotMatchList = [NSMutableArray array];
            for (NSDictionary *hotMatchDic in intdic[@"hotMatchList"]) {
                [hotMatchList safeAddObject:[[LQMatchObj alloc]initWith:hotMatchDic]];
            }
            inobj.hotMatchList = hotMatchList;
        }
    }
    return self;
}

@end
