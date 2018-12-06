//
//  LQFeedbacksReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 意见反馈
 */
@interface LQFeedbacksReq : LQHttpRequest

@property (nonatomic, copy) NSString * content;


@end
