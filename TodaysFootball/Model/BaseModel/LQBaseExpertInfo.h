//
//  LQBaseExpertInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 专家信息
 */
@interface LQBaseExpertInfo : NSObject<LQDecode, LQEncode, LQDataTransformation>

// 用户id
@property (nonatomic) NSInteger  userId;

//用户名称
@property (nonatomic, copy) NSString * nickname;

// 头像地址
@property (nonatomic, copy) NSString * avatar;


@end
