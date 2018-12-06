//
//  LQPlayVoObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 比分对象
 */
@class LQItemOdds, LQExtraOdds, LQItemVo;
@interface LQPlayVoObj : NSObject<LQDecode>
@property (nonatomic) NSInteger playId; // 比分id
@property (nonatomic, strong) NSArray<LQItemVo *> * itemVoList;  // 比分列表
@property (nonatomic, copy) NSString * extraOddsDesc;  // 额外的赔率说明
@property (nonatomic, copy) NSString * playCode;  // 比分码
@property (nonatomic, copy) NSString * playName;  // 比分名
@property (nonatomic, copy) NSString * concede; // 承认
@property (nonatomic, strong) NSArray<LQExtraOdds*> *extraOddsList; // 额外的赔率名单

//********************** 方案详情专用  ********************** //
@property (nonatomic) BOOL isOpen;

@end


@interface LQItemVo :NSObject <LQDecode>
@property (nonatomic, copy) NSString * playItemName; // 主胜
@property (nonatomic) NSInteger isMRecommend; // 是否是我推荐
@property (nonatomic) NSInteger isRecommend; //  是否推荐
@property (nonatomic) NSInteger isMatchResult;  // 是否比赛结果
@property (nonatomic) double  odds; //  赔率
@property (nonatomic) NSInteger playItemId; // id

@property (nonatomic, copy) NSString * playItemCode;
@property (nonatomic) NSInteger extention_id;
@end


@interface LQExtraOdds : NSObject<LQDecode>
@property (nonatomic, copy) NSString * currentConcedeScore; // 目前让分
@property (nonatomic, copy) NSString * oddsCompany; //赔率单位？
@property (nonatomic, strong) NSArray<LQItemOdds *> * itemOddsList;  //
@property (nonatomic, copy) NSString * originConcedeScore; //  让分起点
@end


@interface LQItemOdds : NSObject<LQDecode>
@property (nonatomic) double originOdds;  //  赔率起点
@property (nonatomic, copy) NSString * currentOddsChange;  // 当前赔率更改
@property (nonatomic) double currentOdds;   // 当前赔率
@end

