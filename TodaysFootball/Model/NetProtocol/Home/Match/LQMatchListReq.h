//
//  LQMatchListReq.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/19.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 赛事详情方案列表
 */
@interface LQMatchListReq : LQHttpRequest

@end

@interface LQMatchListRes : LQNetResponse
@property (nonatomic, strong) NSArray * aData;

@end
/*
 expert =     {
 avatar = "https://relottery.nosdn.127.net/user/20171101/m7ec9p.jpg";
 bAllRate = "\U8fd13\U573a\U4e2d2\U573a";
 hitRate = "0.67";
 maxWin = 12;
 nickname = "\U4e01\U4f1f\U6770";
 showHitRate = 1;
 slogan = "\U8db3\U7403\U8bc4\U8bba\U5458";
 userId = 409110;
 };
 plock = 1;
 price = 58;
 publishTime = "8\U5206\U949f\U524d\U53d1\U5e03";
 purchased = 0;
 showType = 3;
 threadId = 60355;
 threadTitle = "\U770b\U597d\U4eca\U665a\U8fd9\U4e24\U573a\U82f1\U8054\U676f\U5f3a\U5f31\U5bf9\U8bdd";
 weight = 60;

 */
