//
//  ExpertObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseExpertInfo.h"

/**
 首页专家对象
 */
@interface ExpertObj : LQBaseExpertInfo
// 控球率
@property (nonatomic, copy) NSString * bAllRate;
// 命中率
@property (nonatomic) CGFloat  hitRate;
// 最大胜场
@property (nonatomic) NSInteger  maxWin;
// 显示的命中率
@property (nonatomic) BOOL  showHitRate;
// 标语
@property (nonatomic, copy) NSString * slogan;

@end

/*
 avatar = "https://relottery.nosdn.127.net/user/20171031/TGrvFX.jpg";
 bAllRate = "\U8fd17\U573a\U4e2d7\U573a";
 hitRate = 1;
 maxWin = 6;
 nickname = "\U5f6d\U4f1f\U56fd";
 showHitRate = 1;
 slogan = "\U524d\U56fd\U811a";
 userId = 407882;
 */
