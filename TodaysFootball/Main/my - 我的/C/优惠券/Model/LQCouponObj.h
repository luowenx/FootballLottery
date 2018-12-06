//
//  LQCouponObj.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 优惠券
 */
@interface LQCouponObj : NSObject<LQDecode, LQDataTransformation>
@property (nonatomic) NSInteger userCouponId;
@property (nonatomic, copy) NSString * couponName;
@property (nonatomic, copy) NSString * couponDesc;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSInteger minAmount;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * typeDesc;
@property (nonatomic, copy) NSString * expirationDate;
@property (nonatomic, copy) NSString * packageName;

@property (nonatomic) LQCouponDiscountType typeId;

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
 "expirationDate": "2018-01-22 12:50:30"
 */
