//
//  LQRankExpertObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseExpertInfo.h"

/**
 排行榜专家对象
 */
@interface LQRankExpertObj : LQBaseExpertInfo

@property (nonatomic, copy) NSString * threadCount;
@property (nonatomic, copy) NSString * earningRate;
@property (nonatomic, copy) NSString * slogan;
@property (nonatomic) NSInteger popularity;


@end
