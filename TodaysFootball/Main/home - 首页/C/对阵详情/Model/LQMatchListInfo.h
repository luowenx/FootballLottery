//
//  LQMatchListInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 比赛列表单个对象
 */
@class ExpertObj;
@interface LQMatchListInfo : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic, strong) ExpertObj * expert; 
@property (nonatomic) NSInteger threadId;
@property (nonatomic) long long publishTime;
@property (nonatomic) NSInteger purchased;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger isWin;
@property (nonatomic) NSInteger weight;
@property (nonatomic, copy) NSString * threadTitle;
@property (nonatomic) LQThreadPlock plock;
@property (nonatomic) NSInteger showType;
@property (nonatomic) NSInteger views;

@property (nonatomic) CGFloat cacheHeight;
@end
/*
 [0]    (null)    @"expert" : 7 key/value pairs
 [1]    (null)    @"publishTime" : @"2018-01-23 19:50:47"
 [2]    (null)    @"purchased" : (long)0
 [3]    (null)    @"price" : (long)18
 [4]    (null)    @"isWin" : (long)1
 [5]    (null)    @"threadTitle" : @"德乙冬歇期后首战，基尔VS柏林联"
 [6]    (null)    @"views" : (long)320
 [7]    (null)    @"plock" : (long)3
 [8]    (null)    @"threadId" : (long)55387
 */
