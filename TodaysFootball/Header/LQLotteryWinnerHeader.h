//
//  LQLotteryWinnerHeader.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/13.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#ifndef LQLotteryWinnerHeader_h
#define LQLotteryWinnerHeader_h

typedef NS_ENUM(NSInteger, LQCouponDiscountType) {
    kLQCouponTypeDiscount = 1,  // 打折
    kLQCouponTypeFullSale = 2,  // 满减
    kLQCouponTypeDirectSale = 3,   //  直减
};


typedef NS_ENUM(NSInteger, LQMatchStatus) {
    kLQMatchStatusNotStart = 1,  // 未开始
    kLQMatchStatusIng,                 // 进行中
    kLQMatchStatusFinished,      //  已结束
    kLQMatchStatusDelay,           //  延期
    kLQMatchStatusCancel,         // 取消
};

typedef NS_ENUM(NSInteger, LQThreadPlock) {
    kLQThreadPlockCanPurchase = 1,       // 可购买
    kLQThreadPlockUnderway,                 // 进行中
    kLQThreadPlockFinished,                    //  已结束
    kLQThreadPlockCancel,                       //  已取消
};

typedef NS_ENUM(NSInteger, LQPurchaseRecordType) {
    kPurchaseLQRecordConsume = 0,      // 消费
    kLQRechargeRecordRecharge = 1,            // 充值
};

#endif /* LQLotteryWinnerHeader_h */
