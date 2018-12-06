//
//  LQUpdateUserReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"


/**
 更改用户信息
 */
@interface LQUpdateUserReq : LQHttpRequest
// 昵称
@property (nonatomic, copy) NSString * nickname;
// 性别
@property (nonatomic, copy) NSString * gender;
// 头像
@property (nonatomic, copy) NSString * avatar;

@end
