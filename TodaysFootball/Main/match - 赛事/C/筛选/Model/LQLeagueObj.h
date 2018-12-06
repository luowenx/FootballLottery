//
//  LQLeagueObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 联赛
 */
@interface LQLeagueObj : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic, copy) NSString * leagueName;

@property (nonatomic) NSInteger leagueId;

@end
