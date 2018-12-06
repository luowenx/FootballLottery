//
//  LQPriceObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPriceObj.h"

@implementation LQPriceObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQPriceObj)
        parserObjAttr(appleGoodsId)
        parserObjAttr(goodsName)
        parserBaseAttr(colorbean, integerValue)
        parserBaseAttr(hot, integerValue)
        parserBaseAttr(goodsPrice, integerValue)
        parserBaseAttr(goodsId, integerValue)
    }
    return self;
}

LQDataTransformationImplementation


@end
