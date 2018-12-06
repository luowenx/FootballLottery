//
//  LQCommsReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 资讯的评论列表
 */
@interface LQCommsReq : LQHttpRequest

@property (nonatomic, copy) NSString * docId;

@end

@interface LQCommsRes: LQNetResponse


@end


