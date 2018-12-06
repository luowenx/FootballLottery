//
//  LQCouponObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCouponObj.h"

@implementation LQCouponObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQCouponObj)
        parserBaseAttr(typeId, integerValue)
        parserBaseAttr(userCouponId, integerValue)
        parserObjAttr(couponName)
        parserObjAttr(couponDesc)
        parserBaseAttr(amount, integerValue)
        parserBaseAttr(minAmount, integerValue)
        parserObjAttr(discount)
        parserObjAttr(typeDesc)
        parserObjAttr(expirationDate)
        parserObjAttr(packageName)
    }
    return self;
}


LQDataTransformationImplementation

@end
