//
//  LQFilterConfiger.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/26.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LQFilterPrerequisite <NSObject>
/**
 筛选
 
 @param leagueIds 联赛id
 */
-(void)filterWithLeague:(NSString *)leagueIds;

/**
 *  筛选数据个数
 *  filter 是否筛选
 *  count 筛选出的数据个数
 */
@property (nonatomic, copy) void (^filterData)(BOOL filter, NSInteger count);
@end

/**
 赛选参数相关设置
 */
@class LQLeagueObj;
@interface LQFilterConfiger : NSObject<NSCopying>

/** 选中选项, 必须保证  selectedOptions 是  showOptions 的子集 */
@property (nonatomic, strong) NSArray<LQLeagueObj *> *selectedOptions;

/** 需要展示的所有选项 */
@property (nonatomic, strong) NSArray<LQLeagueObj *> * showOptions;

/**
 *  第几个列表页
 *  page 1/2/3 对应 实时/赛果/赛程 三个列表页
 */
@property (nonatomic) NSInteger page;

-(NSString *)pram;

// 去除选中数组中不应该有的元素
-(void)check;

// 是否选中了该联赛
-(BOOL)isSelectedObject:(LQLeagueObj *)object;

/**
 选择该联赛
 如果已经选中，则会反选
 */
-(void)selectedObject:(LQLeagueObj *)object;

@end
