//
//  LQDeleteCommReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 删除评论
 */
@interface LQDeleteCommReq : LQHttpRequest

@property (nonatomic, copy) NSString * commId;


@end
