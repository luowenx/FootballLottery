//
//  LQDeleteFavoriteInfo.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 取消比赛资讯收藏
 */
@interface LQDeleteFavoriteInfoReq : LQHttpRequest

@property (nonatomic, copy) NSString *docId;

@end
