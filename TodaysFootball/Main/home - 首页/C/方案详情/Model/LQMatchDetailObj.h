//
//  LQMatchDetailObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 方案详情-比赛详情对象
 */
@class LQTeamInfo, LQPlayVoObj;
@interface LQMatchDetailObj : NSObject<LQDecode, LQDataTransformation>
@property (nonatomic) NSInteger leagueId; //联盟id
@property (nonatomic, copy) NSString * leagueName;  // 联盟名称
@property (nonatomic) long long  matchTime; // 比赛时间
@property (nonatomic) NSInteger homeScore; // 主场分数
@property (nonatomic) NSInteger weight;     // 权
@property (nonatomic, strong) LQTeamInfo * homeTeam;  // 主场队伍
@property (nonatomic, strong) NSArray<LQPlayVoObj*> * playVoList;
@property (nonatomic, copy) NSString * jcNum;
@property (nonatomic) NSInteger guestScore; // 客场分数
@property (nonatomic) LQMatchStatus matchStatus;  // 比赛状态
@property (nonatomic) NSInteger guestId;  // 客场id
@property (nonatomic) NSInteger  matchInfoId; // 比赛信息id
@property (nonatomic, copy) NSString * betOver;  // 赌注
@property (nonatomic) NSInteger focusCount;  // 焦点数
@property (nonatomic) NSInteger threadCount;  // 方案数
@property (nonatomic, copy) NSString * leagueEnName;  // 联盟英文名
@property (nonatomic, strong) LQTeamInfo * guestTeam;  // 客场队伍
@property (nonatomic) NSInteger homeId; // 主场id
@property (nonatomic) NSInteger matchCode;  //比赛码
@property (nonatomic) NSInteger categoryId;  // 类型id
@end
/*
 [0]    (null)    @"homeTeam" : 6 key/value pairs
 [1]    (null)    @"leagueId" : (long)41
 [2]    (null)    @"leagueName" : @"英超"
 [3]    (null)    @"weight" : (long)60  _____________-----------
 [4]    (null)    @"matchCode" : (long)1916314
 [5]    (null)    @"guestTeam" : 6 key/value pairs
 [6]    (null)    @"playVoList" : @"1 element"
 [7]    (null)    @"matchInfoId" : (long)145330
 [8]    (null)    @"matchStatus" : (long)3
 [9]    (null)    @"guestScore" : (long)1
 [10]    (null)    @"jcNum" : @"周六018"
 [11]    (null)    @"matchTime" : @"12/23 23:00"
 [12]    (null)    @"homeScore" : (long)3
 [13]    (null)    @"guestId" : (long)108
 [14]    (null)    @"betOver" : @"2017-12-23 22:55:00"
 [15]    (null)    @"focusCount" : (long)3
 [16]    (null)    @"threadCount" : (long)18-----------_____________
 [17]    (null)    @"leagueEnName" : @"English Premier League"
 [18]    (null)    @"categoryId" : (long)1
 [19]    (null)    @"homeId" : (long)170
 */
