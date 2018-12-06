//
//  LQPersonPlanObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 专家个人的方案
 */
@class LQMatchObj;
@interface LQPersonPlanObj : NSObject<LQDecode, LQDataTransformation>
// 比赛详情
@property (nonatomic, strong) LQMatchObj * earliestMatch;
// 创造价值？
@property (nonatomic, copy) NSString * hitRateValue;
// 是否赢了
@property (nonatomic) NSInteger isWin;
// 爆发
@property (nonatomic) LQThreadPlock  plock;
// 价格
@property (nonatomic) CGFloat price;
// 发表时间
@property (nonatomic) long long publishTime;
// 购买数量
@property (nonatomic) NSInteger  purchased;
// 分数
@property (nonatomic, copy) NSString * score;
// 展示类型  < 1是查看，3是显示要买的豆子？>
@property (nonatomic) NSInteger showType;
// 线程id
@property (nonatomic) NSInteger threadId;
// 线程名称
@property (nonatomic, copy) NSString * title;

@property (nonatomic) NSInteger views;


@property (nonatomic) CGFloat cacheHeight;

@end

/*
earliestMatch =     {
    categoryId = 1;
    guestName = "\U52a0\U7684\U592b\U57ce";
    guestScore = 2;
    homeName = "\U96f7\U4e01";
    homeScore = 2;
    leagueId = 235;
    leagueName = "\U82f1\U51a0";
    matchInfoId = 141100;
    matchStatus = 3;
    matchTime = "12/12";
};
hitRateValue = "2\U4e2d2";
isWin = 1;
plock = 3;
price = 58;
publishTime = "12-11 14:58";
purchased = 0;
score = "3.61451702374";
showType = 1;
threadId = 57816;
title = "\U597d\U72b6\U6001\U4e0d\U80fd\U505c\Uff01\U82f1\U51a0\U897f\U7532\U4e24\U573a\U6bd4\U8d5b\U5206\U6790";
*/
