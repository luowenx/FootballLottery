//
//  LQPlanDetailObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/14.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 方案详情
 */
@class LQExpertDetail, LQMatchDetailObj, LQAvailableCoupon;
@interface LQPlanDetailObj : NSObject<LQDecode>
 // id
@property (nonatomic) NSInteger threadId;
// 是否可购买
@property (nonatomic) BOOL canPurchase;
/**
 可用优惠券列表
 */
@property (nonatomic, strong) NSArray<LQAvailableCoupon *> * couponList;
// 是否命中？
@property (nonatomic) NSInteger isWin;
// 销售结束时间
@property (nonatomic, copy) NSString * saleEndTime;
// 专家数据
@property (nonatomic, strong) LQExpertDetail * expertData;
// 标题
@property (nonatomic, copy) NSString * title;
// 价格
@property (nonatomic) CGFloat price;
// 展示内容
@property (nonatomic) NSInteger  showContent;
// 用户id
@property (nonatomic) NSInteger userId;
//红色货币colorbean
@property (nonatomic) NSInteger colorbean;
// 命中率值
@property (nonatomic, copy) NSString *hitRateValue;
//  比赛详情数据
@property (nonatomic, strong) NSArray<LQMatchDetailObj*> * matchList;
// 发布时间
@property (nonatomic) long long  publishTime;
// 有喜欢的
@property (nonatomic) NSInteger hasFavorite;
// 购买数量
@property (nonatomic) NSInteger purchased;
// 爆发
@property (nonatomic) LQThreadPlock  plock;
// 内容
@property (nonatomic, copy) NSString *content;

@end

/*
 [0]    (null)    @"threadId" : (long)61421
 [1]    (null)    @"canPurchase" : (no summary)
 [2]    (null)    @"isWin" : (long)1
 [3]    (null)    @"saleEndTime" : @"2017-12-23 23:00:00"
 [4]    (null)    @"expertData" : 7 key/value pairs
 [5]    (null)    @"title" : @"【冲击八连红】斯托克城VS西布罗姆、布赖顿VS沃特福德"
 [6]    (null)    @"price" : (long)88
 [7]    (null)    @"showContent" : (long)1
 [8]    (null)    @"userId" : (long)354381
 [9]    (null)    @"redCurrency" : (long)0
 [10]    (null)    @"hitRateValue" : @"1/2"
 [11]    (null)    @"matchList" : @"2 elements"
 [12]    (null)    @"publishTime" : @"12-23 12:06"
 [13]    (null)    @"hasFavorite" : (long)0
 [14]    (null)    @"purchased" : (long)0
 [15]    (null)    @"plock" : (long)3
 [16]    (null)    @"content" : @"<p>之前八连红后，黑了两场。如今又是六连红，我心理压力也有些大。因为，世界上没有常胜将军，体育运动亦然，更别说偶然性巨大的博彩了。谢谢您的信任，但切勿大注。博彩还是小玩怡情为好。\n</p><p><br></p><p><b>斯托克城VS西布罗姆\n</b></p><p>两队均在降级区上下，斯托克城第17，西布朗第19，斯托克城高出2分，但本场一旦输球则将掉入降级区——本场堪称保级六分战。\n</p><p>斯托克城上轮主场0比3负于西汉姆，遭遇三连败，主帅马克·休斯的帅位岌岌可危。其防线本赛季可谓面目全非，18轮后已经丢了39球，为英超最差。\n</p><p>对斯托克城来说，幸运的是，西布朗的前场并无致命杀手。西布朗本赛季甚至没有一人进球能达到3个，这是他们只排倒数第二的根源。也正是因为进攻不佳，珀杜11月接替普利斯后，西布朗战绩并无明显改观。\n</p><p>但无论如何，西布朗防线仍然坚固，过去两轮面对利物浦和曼联，他们客场0比0逼平利物浦，主场1比2憾负于曼联。过去6场各项赛事，西布朗在客场都没有丢到2球。考虑到西布朗的坚强防守，以及斯托克城的糟糕防线，本场西布朗当保不败，甚至可能取胜。预计斯托克城0比1或1比1。\n</p><p><br></p><p><b>布赖顿VS沃特福德\n</b></p><p>布赖顿和沃特福德近来状态都不怎么样。特别是沃特福德，赛季初令人眼前一亮，但最近5场联赛4负1平，几乎前功尽弃。上周六，他们在主场被哈德斯菲尔德灌进4球，此前他们还连续输给了算不上强队的伯恩利和水晶宫，可见这支球队确实遭遇了严重问题，而且可能出在更衣室。\n</p><p>布赖顿也有问题，但主要还是在场上，尤其是攻击力不足。最近6场联赛，他们居然只进了1个球。面对沃特福德过去两轮丢了6球的糟糕防线，布赖顿前锋默里的机会终于来了，他本赛季已进5球，最近6轮本队的唯一进球就是他在1比5负于利物浦一战中攻入。此外，布赖顿防线还算不错，上轮0比0逼平了伯恩利。考虑到沃特福德过去5个客场输了4场，布赖顿本场至少应能不败，预计布赖顿1比0或0比0。\n</p>"
 */
