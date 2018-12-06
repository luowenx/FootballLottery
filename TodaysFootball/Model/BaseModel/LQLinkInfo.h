//
//  LQLinkInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 链接信息
 */
@interface LQLinkInfo : NSObject<LQDecode>
// 描述
@property (nonatomic, copy) NSString *aDescription;
// 图片url
@property (nonatomic, copy) NSString * imgUrl;
// id
@property (nonatomic) NSInteger hId;
// 位置
@property (nonatomic) NSInteger  location;
// 定向url
@property (nonatomic, copy) NSString * redirectUrl;
// 状态
@property (nonatomic, copy) NSString * status;
// 类型
@property (nonatomic, copy) NSString * type;

@end

/*
 description = "\U4e8e\U5609";
 hId = 2;
 imgUrl = "https://relottery.nosdn.127.net/thread/20171211/nLRX2Z.jpg";
 location = 6;
 redirectUrl = "https://c.m.163.com/nc/qa/3g-expand/hc-article.html?docid=D5CN4NDH00058MJK#pcarticle=https://hongcai.163.com/article/17/1211/14/D5CN4NDH00058MJK.html";
 status = online;
 type = url;
 */
