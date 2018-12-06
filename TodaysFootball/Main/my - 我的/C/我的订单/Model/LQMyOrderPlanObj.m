//
//  LQMyOrderPlanObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyOrderPlanObj.h"

@implementation LQMyOrderPlanObj

-(id)initWith:(NSDictionary *)dic
{
    self = [super initWith:dic];
    if (self) {
        startParser(dic, self, LQMyOrderPlanObj)
        parserObjAttr(hitRateValue)
        parserBaseAttr(purchasedTime, integerValue)
        parserBaseAttr(amount, integerValue)
    }
    return self;
}

LQDataTransformationImplementation

@end
