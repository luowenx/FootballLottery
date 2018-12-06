//
//  LQComment.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQComment.h"

/**
 评论
 */
@interface LQInfoComment : LQComment<LQDecode, LQDataTransformation>

@property (nonatomic, strong) LQUserInfo * user;

@property (nonatomic) CGFloat cacheHeight;

@end

/*
 commentTime = 1532421781;
 content = "\U8fd9\U53ea\U662f\U4e00\U6761\U8bc4\U8bba\U800c\U5df2";
 id = 4;
 user =     {
 avatar = "https://thirdqq.qlogo.cn/qqapp/1106835983/67D3B2F98EAD010E24D0D2933C4388C4/100";
 gender = 1;
 nickname = "\U5e05\U6bd4";
 state = 1;
 };
 */
