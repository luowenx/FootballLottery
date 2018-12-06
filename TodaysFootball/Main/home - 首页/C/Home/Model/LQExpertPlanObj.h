//
//  LQExpertPlanObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 专家方案
 */
@class LQMatchObj, ExpertObj;
@interface LQExpertPlanObj : NSObject<LQDecode, LQDataTransformation>
// 早期的比赛
@property (nonatomic, strong) LQMatchObj * earliestMatch;
// 专家
@property (nonatomic, strong) ExpertObj * expert;

@property (nonatomic) BOOL isWin;
// 查看次数
@property (nonatomic) NSInteger views;

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
// 展示类型
@property (nonatomic) NSInteger showType;
// 线程id
@property (nonatomic) NSInteger threadId;
// 线程名称
@property (nonatomic, copy) NSString * threadTitle;
// 权重
@property (nonatomic) NSInteger weight;

/*** 关注的专家方案详情 ***/
@property (nonatomic) BOOL hasThread;
@property (nonatomic, copy) NSString * createTimeStr;

/*** 我的收藏 ***/
@property (nonatomic) long long favoriteTime;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * hitRateValue;

// 缓存高度
@property (nonatomic) CGFloat cacheHeight;

@end
/*
 [0]    (null)    @"expert" : 6 key/value pairs
 [1]    (null)    @"threadId" : (long)48622
 [2]    (null)    @"publishTime" : @"11-14 11:18"
 [3]    (null)    @"purchased" : (long)0
 [4]    (null)    @"createTimeStr" : @"2017-11-14 11:18:13"
 [5]    (null)    @"price" : (long)88
 [6]    (null)    @"threadTitle" : @"德国vs法国，强强对话，会出现什么结果？"
 [7]    (null)    @"earliestMatch" : 10 key/value pairs
 [8]    (null)    @"hasThread" : (no summary)
 [9]    (null)    @"plock" : (long)3
 [10]    (null)    @"showType" : (long)1
 */

/*
 earliestMatch =                 {
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
 expert =                 {
 avatar = "https://relottery.nosdn.127.net/user/20171031/TGrvFX.jpg";
 bAllRate = "\U8fd17\U573a\U4e2d7\U573a";
 hitRate = 1;
 maxWin = 6;
 nickname = "\U5f6d\U4f1f\U56fd";
 showHitRate = 1;
 slogan = "\U524d\U56fd\U811a";
 userId = 407882;
 };
 plock = 1;
 price = 58;
 publishTime = "5\U5c0f\U65f6\U524d\U53d1\U5e03";
 purchased = 0;
 score = "5090100.6146693";
 showType = 3;
 threadId = 58039;
 threadTitle = "11\U8fde\U7ea2\Uff0c\U4eca\U5929\U5e26\U6765\U4e24\U573a\U82f1\U8d85\U5206\U6790";
 weight = 90;
 */
