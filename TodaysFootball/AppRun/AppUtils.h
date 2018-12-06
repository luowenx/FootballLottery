//
//  AppUtils.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 APP 基本参数
 */
@interface AppUtils : NSObject


//初始化,更新本地信息，
+ (void)appInitial;

@end


@interface AppUtils (info)
//  app 名字
+(NSString *)bundleName;
// 版本号： 编译版本号
+(NSString *)bundleVersion;
// 版本号：线上版本号
+(NSString *)bundleShortVersion;
// 
+(NSString *)bundleid;
@end
