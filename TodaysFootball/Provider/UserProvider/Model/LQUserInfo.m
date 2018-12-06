//
//  LQUserInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQUserInfo.h"

@implementation LQUserInfo

-(instancetype)initWith:(NSDictionary *)dic
{
    if (!dic) { return nil; }
    self = [super init];
    if (!self) {return nil;}
    // 解析属性
    
    startParser(dic, self, LQUserInfo)
    parserObjAttr(nickName)
    parserDiffObjAttr(nickName, @"nickname")
    parserObjAttr(avatar)
    parserBaseAttr(colorbean, integerValue)
    parserObjAttr(mobile)
    parserBaseAttr(state, integerValue)
    
    if (lqpIsJsonElementValid(intdic, @"gender", NULL)) {
        inobj.gender = stringNotNil(intdic[@"gender"]);
    }

    return  self;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    __setObjAttr(json, nickName)
    __setObjAttr(json, avatar)
    __setObjAttr(json, gender)
    __setBaseAttrInsist(json, colorbean)
    __setObjAttr(json, mobile)
    __setBaseAttrInsist(json, state)
    
    return json.copy;
}

@end
