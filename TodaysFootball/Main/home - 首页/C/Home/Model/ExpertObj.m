//
//  ExpertObj.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "ExpertObj.h"

@implementation ExpertObj

-(id)initWith:(NSDictionary *)dic
{
    self = [super initWith:dic];
    if (self) {
        startParser(dic, self, ExpertObj)
        parserObjAttr(bAllRate)
        parserObjAttr(slogan)

        parserBaseAttr(hitRate, floatValue)
        parserBaseAttr(maxWin, integerValue)
        parserBaseAttr(showHitRate, boolValue)
    }
    return self;
}

LQDataTransformationImplementation

-(NSDictionary *)toJSON
{
    NSMutableDictionary *dic = [super toJSON].mutableCopy;
    __setObjAttr(dic, bAllRate)
    __setObjAttr(dic, slogan)
    __setBaseAttrInsist(dic, hitRate)
    __setBaseAttrInsist(dic, maxWin)
    __setBaseAttrInsist(dic, showHitRate)
    return dic.copy;
}

@end
