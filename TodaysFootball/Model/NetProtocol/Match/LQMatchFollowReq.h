//
//  LQMatchFollowReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 赛事--关注 api
 */
@interface LQMatchFollowReq : LQHttpRequest

@end

@interface LQMatchFollowRes : LQNetResponse

@property (nonatomic, strong) NSArray * matchList;
//@property (nonatomic) NSInteger matchCount;

@end
