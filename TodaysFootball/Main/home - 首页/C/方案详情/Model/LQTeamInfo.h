//
//  LQTeamInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 队伍信息
 */
@interface LQTeamInfo : NSObject<LQDecode>
@property (nonatomic, copy) NSString * teamIcon;   // 队伍icon
@property (nonatomic) NSInteger teamId;   // 队伍id
@property (nonatomic, copy) NSString * teamName;   // 队伍名称
@property (nonatomic, copy) NSString * teamEnName;  // 队伍英文名
@property (nonatomic) NSInteger todaysfootballCategoryId;  // 彩票类别id
@property (nonatomic) NSInteger teamCode;   // 队伍码
@end

/*
 [0]    (null)    @"teamIcon" : @"https://relottery.nosdn.127.net/match/soccer/2_586.jpg"
 [1]    (null)    @"teamId" : (long)1000
 [2]    (null)    @"teamName" : @"SBV精英"
 [3]    (null)    @"teamEnName" : @"SBV Excelsior"
 [4]    (null)    @"lotteryCategoryId" : (long)1
 [5]    (null)    @"teamCode" : (long)586
 */
