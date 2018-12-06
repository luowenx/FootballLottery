//
//  LQPlanFavoritesReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 方案收藏 api
 */
@interface LQPlanFavoritesReq : LQHttpRequest

@property (nonatomic, copy) NSString * threadId;

@end
