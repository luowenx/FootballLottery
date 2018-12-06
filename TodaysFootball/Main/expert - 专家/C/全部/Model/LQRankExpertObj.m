//
//  LQRankExpertObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQRankExpertObj.h"

@implementation LQRankExpertObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super initWith:dic];
    if (self) {
        startParser(dic, self, LQRankExpertObj)
        parserObjAttr(earningRate)
        parserObjAttr(threadCount)
        parserObjAttr(slogan)
        parserBaseAttr(popularity, integerValue)

    }
    return self;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *dic = [super toJSON].mutableCopy;
    
    __setObjAttr(dic, threadCount);
    __setObjAttr(dic, earningRate);
    __setObjAttr(dic, slogan);
    __setBaseAttrInsist(dic, popularity)
    
    return dic;
}

LQDataTransformationImplementation

@end
