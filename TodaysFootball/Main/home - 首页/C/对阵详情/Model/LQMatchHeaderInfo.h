//
//  LQMatchHeaderInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/3/5.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQTeamInfo.h"
#import "LQLeagueObj.h"

/**
 比赛列表头部信息
 */
@interface LQMatchHeaderInfo : NSObject<LQDecode>

@property (nonatomic) NSInteger guestScore;  // 客场分数
@property (nonatomic, strong) LQTeamInfo * guestTeam; // 客场队伍
@property (nonatomic) BOOL hasFollowed;  // 是否关注
@property (nonatomic) NSInteger homeScore;  // 主场分数
@property (nonatomic, strong) LQTeamInfo * homeTeam;  // 主场队伍
@property (nonatomic) BOOL isJc;
@property (nonatomic, strong) LQLeagueObj * leagueMatch;  // 联盟
@property (nonatomic) NSInteger todaysfootballCategoryId; // 类型id
@property (nonatomic) NSInteger matchInfoId;  //赛事id
@property (nonatomic) LQMatchStatus matchStatus;  //赛事状态
@property (nonatomic) long long matchTime;   // 比赛时间
@property (nonatomic) NSInteger threadCount;  // 方案个数
@property (nonatomic, strong) NSDictionary * webView; //

@end

/*
 guestScore = 0;
 guestTeam =     {
 teamIcon = "https://relottery.nosdn.127.net/match/soccer/2_592.jpg";
 teamId = 1044;
 teamName = "\U5948\U6885\U4ea8";
 };
 hasFollowed = 0;
 homeScore = 0;
 homeTeam =     {
 teamIcon = "https://relottery.nosdn.127.net/match/soccer/2_128.jpg";
 teamId = 243;
 teamName = "\U5179\U6c83\U52d2";
 };
 isJc = 1;
 leagueMatch =     {
 leagueId = 196;
 leagueName = "\U8377\U5170\U676f";
 };
 lotteryCategoryId = 1;
 matchInfoId = 144310;
 matchStatus = 1;
 matchTime = "12-20 01:30";
 threadCount = 11;
 webView =     {
 guestTeamUrl = "https://163sports.mc.sportsdt.com/data/data/team/team_info_gb.shtml?id=592";
 homeTeamUrl = "https://163sports.mc.sportsdt.com/data/data/team/team_info_gb.shtml?id=128";
 live = "";
 };
 
 */
