//
//  LQExpertDetail.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "ExpertObj.h"

/**
 专家详情
 */
@interface LQExpertDetail : ExpertObj

// 擅长的联盟？
@property (nonatomic, strong ) NSArray *beGoodAtLeague;
// 反对的赢？
@property (nonatomic) NSInteger conWin;
// 详情链接
@property (nonatomic, copy) NSString * descLink;
// 描述
@property (nonatomic, copy) NSString * aDescription;
// 追随者？关注人数？
@property (nonatomic) NSInteger  follower;
// 是否关注了
@property (nonatomic) NSInteger  hasFollowed;
// 联赛统计
@property (nonatomic, strong) NSArray * leagueMatchStats;
// 领域？
@property (nonatomic) NSInteger region;

@end

/*
 avatar = "https://relottery.nosdn.127.net/user/20171031/TGrvFX.jpg";
 bAllRate = "\U8fd17\U573a\U4e2d7\U573a";
 beGoodAtLeague =     (
 );
 conWin = 6;
 descLink = "https://c.m.163.com/nc/qa/3g-expand/hc-article.html?docid=D254P93800058MJK#pcarticle=https://hongcai.163.com/article/17/1101/08/D254P93800058MJK.html";
 description = "\U524d\U56fd\U811a\Uff0c\U66fe\U6548\U529b\U5e7f\U5dde\U592a\U9633\U795e\U548c\U6df1\U5733\U961f\Uff0c\U9000\U5f79\U540e\U62c5\U4efb\U6052\U5927\U9884\U5907\U961f\U4e3b\U5e05\U548cU22\U7537\U8db3\U52a9\U6559\U3002";
 follower = 757;
 hasFollowed = 0;
 hitRate = 1;
 leagueMatchStats =     (
 );
 maxWin = 6;
 nickname = "\U5f6d\U4f1f\U56fd";
 region = 0;
 slogan = "\U524d\U56fd\U811a";
 userId = 407882;
 */
