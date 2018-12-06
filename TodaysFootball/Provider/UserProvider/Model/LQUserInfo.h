//
//  LQUserInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户信息基类
 */
@interface LQUserInfo : NSObject<LQDecode, LQEncode>

@property (nonatomic, copy) NSString *  nickName;

@property (nonatomic, copy) NSString * avatar;

@property (nonatomic, copy) NSString  *gender;

// 彩豆数量
@property (nonatomic) NSInteger colorbean;
//  手机号
@property (nonatomic, copy) NSString * mobile;

@property (nonatomic) NSInteger  state; // 登录状态

@end
