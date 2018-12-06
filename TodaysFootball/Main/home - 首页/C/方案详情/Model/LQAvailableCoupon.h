//
//  LQAvailableCoupon.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 可用优惠券
 */
@interface LQAvailableCoupon : NSObject<LQDecode, LQDataTransformation>
@property (nonatomic, copy) NSString *userCouponId;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSInteger minAmount;
@property (nonatomic) LQCouponDiscountType typeId;
@property (nonatomic) NSInteger realCost;
@property (nonatomic, copy) NSString * couponName;
@property (nonatomic, copy) NSString * couponDesc;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * typeDesc;
@property (nonatomic, copy) NSString * expirationDate;
@property (nonatomic, copy) NSString * tips;
@property (nonatomic, copy) NSString * packageName;


// 运行时逻辑数据
// 是否被使用
@property (nonatomic) BOOL used;

@end

/*
 "userCouponId": 1,
 "couponName": "满58减20",
 "couponDesc": "满58可用",
 "amount": 20,
 "minAmount": 58,
 "discount": "0.0",
 "typeId": 2,
 "typeDesc": "满减",
 "expirationDate": "2018-01-22 12:50:30",
 "tips": "使用满减券优惠20彩豆",
 "realCost": 38
 */
