//
//  LQInformation.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInformation.h"

@implementation LQInformation

-(id)initWith:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) { return nil; }
    self = [super init];
    if (!self) {return nil; }
    
    startParser(dic, self, LQInformation)
    parserObjAttr(coverImg)
    parserObjAttr(docId)
    parserObjAttr(publishTime)
    parserObjAttr(title)
    parserObjAttr(url)
    
    return self;
}

LQDataTransformationImplementation

@end
