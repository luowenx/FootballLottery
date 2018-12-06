//
//  LQPostCommReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 发表评论
 */
@interface LQPostCommReq : LQHttpRequest

@property (nonatomic, copy) NSString *docId;

@property (nonatomic, copy) NSString *content;

@end
