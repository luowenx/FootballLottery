//
//  LQLinkInfo.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQLinkInfo.h"

@implementation LQLinkInfo

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) return nil;
    if (self) {
        startParser(dic, self, LQLinkInfo)
        parserDiffObjAttr(aDescription, @"description")
        parserBaseAttr(hId, integerValue)
        parserObjAttr(imgUrl)
        parserBaseAttr(location, integerValue)
        parserObjAttr(redirectUrl)
        parserObjAttr(status)
        parserObjAttr(type)
    }
    return self;
}

@end
