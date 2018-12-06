//
//  LQAppConfiger.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 应用配置文件
 */
@interface LQAppConfiger : NSObject

+ (instancetype)shareInstance;

/**
 *  app审核状态，NO -> 正在审核状态， yes -> 通过审核
 *  持久化
 */
@property (nonatomic) BOOL appStatus;

/**
 开机接口
 */
- (void)boot;
- (void)forceBoot;

/**
 token 过期请求
 */
- (void)getRegisterToken;

/*
 更新检查逻辑
 */
-(void)versionCheck;

@end


@interface LQVersionObj : NSObject<LQDecode, LQEncode>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic) NSInteger versionCode;
@property (nonatomic, copy) NSString * versionName;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic) BOOL forceUpdate;
@property (nonatomic, copy) NSString * downloadUrl;
@property (nonatomic, copy) NSString * checksum;
@property (nonatomic) NSInteger alert;
@end
