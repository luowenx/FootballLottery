//
//  LQPlanDetailObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPlanDetailObj.h"
#import "LQExpertDetail.h"
#import "LQMatchDetailObj.h"
#import "LQAvailableCoupon.h"

@implementation LQPlanDetailObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQPlanDetailObj)
        parserBaseAttr(threadId, integerValue)
        parserBaseAttr(canPurchase, boolValue)
        parserBaseAttr(isWin, integerValue)
        parserObjAttr(saleEndTime)
        parserObjAttr(title)
        parserBaseAttr(price, floatValue)
        parserBaseAttr(showContent, integerValue)
        parserBaseAttr(userId, integerValue)
        parserBaseAttr(colorbean, integerValue)
        parserObjAttr(hitRateValue)
        parserBaseAttr(publishTime, longLongValue)
        parserBaseAttr(hasFavorite, integerValue)
        parserBaseAttr(purchased, integerValue)
        parserBaseAttr(plock, integerValue)
        parserObjAttr(content)
        
        if (lqpIsJsonElementValid(intdic, @"matchList", NULL)) {
            inobj.matchList = [LQMatchDetailObj objArrayWithDics:intdic[@"matchList"]];
        }
        
        if (lqpIsJsonElementValid(intdic, @"expertData", NULL)) {
            inobj.expertData = [[LQExpertDetail alloc] initWith:intdic[@"expertData"]];
        }
        
        if (lqpIsJsonElementValid(intdic, @"couponList", NULL)) {
            inobj.couponList = [LQAvailableCoupon objArrayWithDics:intdic[@"couponList"]];
        }
    }
    return  self;
}

@end
