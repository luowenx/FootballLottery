//
//  LQDetailInfomationViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQWebViewCtrl.h"

/**
 赛事资讯详情
 */
@class LQInformation;
@interface LQDetailInfomationViewCtrl : LQWebViewCtrl

@property (nonatomic, strong) LQInformation *infoObj;

@end
