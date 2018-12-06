//
//  LQPurchaseRecord.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/15.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQPurchaseRecord.h"

@implementation LQPurchaseRecord

LQDataTransformationImplementation

-(id)initWith:(NSDictionary *)dic
{
    if(!dic || ![dic isKindOfClass:[NSDictionary class]]) return nil;
    self  = [super init];
    if (!self) return nil;
    startParser(dic, self, LQPurchaseRecord)
    parserBaseAttr(amount, integerValue)
    parserBaseAttr(type, integerValue)
    parserBaseAttr(expenseTime, longLongValue)
    parserObjAttr(remark)
    
    return self;
}

@end
