//
//  LQPriceObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 价格
 */
@interface LQPriceObj : NSObject <LQDataTransformation, LQDecode>
@property (nonatomic) NSInteger colorbean;
@property (nonatomic) NSInteger hot;
@property (nonatomic) NSInteger goodsPrice;
@property (nonatomic) NSInteger goodsId;
@property (nonatomic, copy) NSString * appleGoodsId;
@property (nonatomic, copy) NSString * goodsName;

@end

/*
 [0]    (null)    @"colorbean" : (long)30
 [1]    (null)    @"hot" : (long)0
 [2]    (null)    @"goodsPrice" : (long)30
 [3]    (null)    @"goodsId" : (long)1
 [4]    (null)    @"appleGoodsId" : @"com.lequwuxian.lotterywinner.colorbean.30"
 [5]    (null)    @"goodsName" : @"30彩豆"    
 */
