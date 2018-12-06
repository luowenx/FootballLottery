//
//  LQMyTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的--头部--登录之后
 */
@interface LQMyTableViewCell : UITableViewCell
// 彩豆余额
@property (nonatomic, strong) UILabel * beanLabel;
// 头像
@property (nonatomic, strong) UIImageView * avatarImageView;
// 昵称
@property (nonatomic, strong) UILabel * nameLabel;

/**
 设置
 */
@property (nonatomic, copy) void (^setting)(void);

/**
 充值
 */
@property (nonatomic, copy) void (^recharge)(void);

/**
 余额
 */
@property (nonatomic, copy) void (^balance)(void);

@end
