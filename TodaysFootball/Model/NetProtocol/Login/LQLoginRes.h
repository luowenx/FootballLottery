//
//  LQLoginRes.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQNetResponse.h"

/**
 登录接口返回
 */
@interface LQLoginRes : LQNetResponse
// 昵称
@property (nonatomic, copy) NSString * nickname;
// 头像
@property (nonatomic, copy) NSString * avatar;
// 性别
@property (nonatomic, copy) NSString * gender;
// 审核状态
@property (nonatomic) BOOL state;
// 彩豆
@property (nonatomic) NSInteger colorbean;
//  手机号
@property (nonatomic, copy) NSString * mobile;
@end
