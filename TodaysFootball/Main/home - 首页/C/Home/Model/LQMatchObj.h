//
//  LQMatchObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 比赛模型    、、 热门比赛
 */
@interface LQMatchObj : NSObject <LQDecode>
// 类型id
@property (nonatomic) NSInteger categoryId;
// 客场名称
@property (nonatomic, copy) NSString *guestName;
// 客场分数
@property (nonatomic) NSInteger guestScore;
// 主场名称
@property (nonatomic, copy) NSString *homeName;
// 主场分数
@property (nonatomic) NSInteger homeScore;
// 联盟id
@property (nonatomic) NSInteger leagueId;
// 联盟名称
@property (nonatomic, copy) NSString * leagueName;
// 具体比赛id
@property (nonatomic) NSInteger matchInfoId;
// 比赛状态
@property (nonatomic) LQMatchStatus matchStatus;
// 比赛时间
@property (nonatomic) long long  matchTime;

/** 热门比赛 */
// 客场图片地址
@property (nonatomic, copy) NSString * guestIcon;
// 主场图片地址
@property (nonatomic, copy) NSString * homeIcon;
// 比赛时间
@property (nonatomic) long long matchDate;

@end

/*
 {
 categoryId = 1;
 guestName = "\U65af\U6258\U514b\U57ce";
 guestScore = 0;
 homeName = "\U4f2f\U6069\U5229";
 homeScore = 0;
 leagueId = 41;
 leagueName = "\U82f1\U8d85";
 matchInfoId = 141428;
 matchStatus = 1;
 matchTime = "12/13";
 };
 */
