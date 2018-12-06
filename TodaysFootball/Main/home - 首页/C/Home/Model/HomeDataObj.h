//
//  HomeDataObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 首页数据模型
 */
@class RecommendExpertObj, LQExpertPlanObj, LQLinkInfo, LQMatchObj;
@interface HomeDataObj : NSObject<LQDecode>

// 推荐专家列表
@property (nonatomic, strong) NSArray <RecommendExpertObj*>* recommendExpertList;
// 选择专家计划列表
@property (nonatomic, strong) NSArray <LQExpertPlanObj *>* selectExpertPlanList;
// 轮播图片？？
@property (nonatomic, strong) NSArray <LQLinkInfo*> * headList;
// 热门比赛数据
@property (nonatomic, strong) NSArray <LQMatchObj*>* hotMatchList;

@property (nonatomic) NSInteger  freeThreadCount;

@property (nonatomic) NSInteger  followNewThreadCount;

@end
