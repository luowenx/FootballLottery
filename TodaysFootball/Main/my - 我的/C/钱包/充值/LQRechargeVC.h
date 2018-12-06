//
//  LQRechargeVC.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQScrollViewCtrl.h"

/**
 充值页面
 */
@interface LQRechargeVC : LQScrollViewCtrl

/**
 充值完成是否返回上一页

 @param pop <#pop description#>
 @return <#return value description#>
 */
-(instancetype)initWithCommitPop:(BOOL)pop;

@property (nonatomic, readonly) BOOL needPop;

@end
