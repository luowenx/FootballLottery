//
//  LQAvailableCoupon.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQAvailableCoupon.h"

@implementation LQAvailableCoupon
LQDataTransformationImplementation

-(id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) { return nil;  }
    self = [super init];
    if (!self) { return nil; }
    
    startParser(dic, self, LQAvailableCoupon)
    
    parserBaseAttr(amount, integerValue)
    parserBaseAttr(minAmount, integerValue)
    parserBaseAttr(typeId, integerValue)
    parserBaseAttr(realCost, integerValue)

    parserObjAttr(userCouponId)
    parserObjAttr(couponName)
    parserObjAttr(couponDesc)
    parserObjAttr(discount)
    parserObjAttr(typeDesc)
    parserObjAttr(expirationDate)
    parserObjAttr(tips)
    parserObjAttr(packageName)
    
    self.used = YES;
    return self;
}


@end
