//
//  LQMacthShowObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 赛事 -- 比赛对象
 */
@class LQTeamInfo, LQplayObj, LQMatchInfo, LQplayInfo;
@interface LQMacthShowObj : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic, strong) LQplayObj * play;
@property (nonatomic) NSInteger threadCount;
@property (nonatomic) NSInteger homeScore;
@property (nonatomic, strong) LQTeamInfo * homeTeam;
@property (nonatomic) NSInteger guestScore;
@property (nonatomic) LQMatchStatus matchStatus;
@property (nonatomic) NSInteger favPushStatus;
@property (nonatomic, strong) LQMatchInfo * leagueMatch;
@property (nonatomic) unsigned long long  time;
@property (nonatomic) NSInteger todaysfootballCategoryId;
@property (nonatomic) NSInteger matchInfoId;
@property (nonatomic) long long matchTime;
@property (nonatomic, strong) LQTeamInfo * guestTeam;
@property (nonatomic) NSInteger hasFilterOdds;
@property (nonatomic) NSInteger hasLive;

/**** 运行时属性 ******/
@property (nonatomic, copy) NSString *recordString;

@property (nonatomic, copy) NSString * matchDate;

@end

@interface LQplayObj : NSObject<LQDecode>
@property (nonatomic, copy) NSString * playCode;
@property (nonatomic, strong) NSArray<LQplayInfo *> * playItemList;
@property (nonatomic) NSInteger playId;
@property (nonatomic, copy) NSString * concede;

@end

@interface LQMatchInfo : NSObject <LQDecode, LQEncode>
@property (nonatomic, copy) NSString * leagueName;
@property (nonatomic) NSInteger leagueId;
@end

@interface LQplayInfo : NSObject <LQDecode, LQDataTransformation>
@property (nonatomic) double odds;
@property (nonatomic, copy) NSString * playItemCode;
@property (nonatomic) NSInteger playItemId;
@property (nonatomic, copy) NSString * playItemName;
@end
