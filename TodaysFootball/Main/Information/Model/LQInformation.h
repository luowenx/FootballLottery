//
//  LQInformation.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 资讯数据
 */
@interface LQInformation : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic, copy) NSString * coverImg;

@property (nonatomic, copy) NSString * docId;

@property (nonatomic, copy) NSString * publishTime;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * url;

@property (nonatomic) BOOL isFavorit;

@end

/**
coverImg = "http://dl.lequ.net/pic/lw/2018/07/20/24f86c6c248629b0074c804317749744.png";
docId = DN616I0900058781;
publishTime = "2018-07-20 16:27:30";
title = "\U6700\U8d35\U8f6c\U4f1a\U8d39\U9635\U5bb9!\U4ef7\U503c10\U4ebf\U82f1\U9551 \U7ea2\U519b\U84dd\U6708\U4eae\U5236\U9738\U9632\U7ebf";
url = "http://lw.lequ.net/news/DN616I0900058781";
}
*/
