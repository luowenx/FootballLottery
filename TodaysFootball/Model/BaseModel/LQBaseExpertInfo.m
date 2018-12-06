//
//  LQBaseExpertInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseExpertInfo.h"

@implementation LQBaseExpertInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    self = [super init];
    if (self) {
        startParser(dic, self, LQBaseExpertInfo)
        
        parserObjAttr(nickname)
        parserObjAttr(avatar)

        parserBaseAttr(userId, integerValue)
    }
    return self;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];

    __setBaseAttrInsist(dic, userId)
    __setObjAttr(dic, nickname)
    __setObjAttr(dic, avatar)
    return dic.copy;
}

LQDataTransformationImplementation

@end
