//
//  LQAllExpertReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 所以专家 api
 */
@interface LQAllExpertReq : LQHttpRequest

@end

@interface LQAllExpertRes : LQNetResponse

@property (nonatomic, strong) NSArray *expers;

@end

