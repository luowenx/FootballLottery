//
//  LQCouponViewModel.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQCouponObj.h"

typedef NS_ENUM(NSInteger, LQCouponType) {
    kLQCouponTypeOwned = 1,  // 未使用
    kLQCouponTypeUsed,    /// 已使用
    kLQCouponTypeOverdue,   // 已过期
};

/**
 优惠券模型类
 */
@interface LQCouponViewModel : NSObject

@property (nonatomic) LQCouponType type;

/**  数据源  */
@property (nonatomic, copy, readonly) NSArray *dataList;
/**  空字符串  */
@property (nonatomic, copy, readonly) NSString * emptyString;
@property (nonatomic, copy, readonly) NSString * emptyImageName;
@property (nonatomic, readonly) BOOL emptyUserInteractionEnabled;


/**
 获取数据

 @param callBack 回调
 */
-(void)pullDataWithCallBack:(void(^)(BOOL success, NSError *error))callBack;

@end
