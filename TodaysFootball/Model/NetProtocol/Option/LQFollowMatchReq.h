//
//  LQFollowMatchReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"


/**
 赛事关注
 */
@interface LQFollowMatchReq : LQHttpRequest

@property (nonatomic, copy) NSString * matchInfoId;


@end
