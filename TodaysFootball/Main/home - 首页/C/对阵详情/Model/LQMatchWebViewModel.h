//
//  LQMatchWebViewModel.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MatchWebViewShowType) {
    kMatchWebViewShowTypeNone = 0,      // 显示方案
    kMatchWebViewShowTypeData,      // 数据
    kMatchWebViewShowTypeReport,  // 情报
    kMatchWebViewShowTypeCompensate,   // 欧赔
    kMatchWebViewShowTypeTotalScore,    //  大小球
    kMatchWebViewShowTypeLive,    // 直播
};


/**
 比赛详情页、几个web页显示逻辑
 */
@interface LQMatchWebViewModel : NSObject

@property (nonatomic, readonly) MatchWebViewShowType showType;

@property (nonatomic, copy, readonly) NSString * webUrl;


/**
 切换web页显示的内容
 */
-(void)updateShowType:(MatchWebViewShowType)showType;

-(void)setMatchId:(NSString *)matchID;

@end
