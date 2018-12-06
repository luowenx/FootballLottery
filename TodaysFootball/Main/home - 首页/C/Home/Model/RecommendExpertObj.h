//
//  RecommendExpertObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LQBaseExpertInfo.h"
/**
 推荐专家
 */
@interface RecommendExpertObj : NSObject<LQDecode>

@property (nonatomic) NSInteger  cId;

@property (nonatomic, strong) NSArray <LQBaseExpertInfo*>*expertList;

@end
