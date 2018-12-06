//
//  LQNeedLoginHeaderView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的 - 需要登录的头部视图
 */
@interface LQNeedLoginHeaderView : UITableViewCell

/**
 某种方式登录
 */
@property (nonatomic, copy) void (^login)(LQLoginWayType useType);

/**
 设置
 */
@property (nonatomic, copy) void (^setting)(void);

/**
 充值
 */
@property (nonatomic, copy) void (^recharge)(void);

@end
