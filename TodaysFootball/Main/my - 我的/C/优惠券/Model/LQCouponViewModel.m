//
//  LQCouponViewModel.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCouponViewModel.h"
#import "LQCouponsListReq.h"

@interface LQCouponViewModel()

@property (nonatomic, strong) NSMutableArray * ownedList;
@property (nonatomic, strong) NSMutableArray * usedList;
@property (nonatomic, strong) NSMutableArray * overdueList;

@property (nonatomic, copy) NSString * netReachableString;


@end

@implementation LQCouponViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ownedList = @[].mutableCopy;
        self.usedList = @[].mutableCopy;
        self.overdueList = @[].mutableCopy;
        self.type = kLQCouponTypeOwned;
    }
    return self;
}

-(void)pullDataWithCallBack:(void(^)(BOOL success, NSError *error))callBack
{
    if (self.dataList.count>0) { /// 先写有数据不请求
        callBack?callBack(YES, nil):nil;
        return;
    }
    NSString *type = @(self.type).stringValue;
    NSString *offset = @"0";
    NSString *limit = @"20";
    LQCouponsListReq *req = [[LQCouponsListReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@/%@", type, offset, limit]];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret != kLQNetResponseSuccess) {
            callBack?callBack(NO, nil):nil;
            return;
        }
        NSArray *array = [LQCouponObj objArrayWithDics:res.data];
        switch (self.type) {
            case kLQCouponTypeOwned:{
                self.ownedList = array.mutableCopy;
                break;
            }
            case kLQCouponTypeUsed:{
                self.usedList = array.mutableCopy;
                break;
            }
            case kLQCouponTypeOverdue:{
                self.overdueList = array.mutableCopy;
                break;
            }
            default:
                break;
        }
        callBack?callBack(YES, nil):nil;
        self.netReachableString = nil;
    } error:^(NSError *error) {
        callBack?callBack(NO, error):nil;
        if (self.dataList.count>0) {
            return;
        }
        if (error.code == kLQNetErrorCodeNotReachable) {
            self.netReachableString = @"点击屏幕重新加载";
        }
    }];
}


-(NSArray *)dataList
{
    switch (self.type) {
        case kLQCouponTypeOwned:
            return self.ownedList.copy;
            break;
        case kLQCouponTypeUsed:
            return self.usedList.copy;
            break;
        case kLQCouponTypeOverdue:
            return self.overdueList.copy;
            break;
        default:
            return self.ownedList.copy;
            break;
    }
}

-(NSString *)emptyString
{
    if (self.netReachableString.length>0) {
        return self.netReachableString;
    }
    switch (self.type) {
            case kLQCouponTypeOwned:
            return @"您没有可使用的优惠券";
            case kLQCouponTypeUsed:
            return @"您没有已使用的优惠券";
            case kLQCouponTypeOverdue:
            return @"您没有已过期的优惠券";
        default:
            return @"";
            break;
    }
}

-(NSString *)emptyImageName
{
    if (self.netReachableString.length>0) {
        return @"notNetReachable";
    }
    return @"empty_2";
}

-(BOOL)emptyUserInteractionEnabled
{
    return self.netReachableString.length>0;
}

@end
