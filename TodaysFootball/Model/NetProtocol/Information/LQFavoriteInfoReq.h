//
//  LQFavoriteInfoReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 收藏比赛资讯
 */
@interface LQFavoriteInfoReq : LQHttpRequest

@property (nonatomic, copy) NSString *docId;

@end
