//
//  LQMeComment.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQComment.h"
#import "LQInformation.h"

/**
 我的评论
 */
@interface LQMeComment : LQComment

@property (nonatomic, strong) LQInformation *doc;

@property (nonatomic) CGFloat  cacheHeight;

@end

/*
 {
 commentTime = 1532429385;
 content = "\U518d\U6765\U4e00\U6761";
 doc =             {
 coverImg = "http://dl.lequ.net/pic/lw/2018/07/24/7ade1505dd37f254130529a5de9b51d4.png";
 docId = DNGDFUKN00058781;
 publishTime = 1532423686;
 title = "\U65af\U79d1\U5c14\U65af:\U5982\U679c\U74dc\U5e05\U6267\U6559\U66fc\U8054 \U4ed6\U4f1a\U6068\U6b7b\U7a46\U5e05\U7684\U98ce\U683c";
 url = "https://hong.lequ.net/news/DNGDFUKN00058781";
 };
 id = 7;
 }
 */
