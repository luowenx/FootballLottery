//
//  LQPerMatchTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQBeanView.h"

/**
 专家详情cell
 */
@interface LQPerMatchTableViewCell : UITableViewCell

// 默认显示VS  可能显示比分
@property (nonatomic, strong) UILabel * VSLabel;

@property (nonatomic, strong) UILabel * titleLabel;  // 标题
@property (nonatomic, strong) UILabel * matchLabel;  // 赛事（欧冠）
@property (nonatomic, strong) UILabel * ranksLeftLabel;   // 左边队伍
@property (nonatomic, strong) UILabel * ranksRightLabel;   // 右边队伍
@property (nonatomic, strong) UILabel * scoreLabel;   // 比分
@property (nonatomic, strong) UILabel * timeLabel; // 时间
@property (nonatomic, strong) LQBeanView * beanView;  // 彩豆
@property (nonatomic, strong) UIButton * lookButton; // 查看
@property (nonatomic, strong) UILabel * lookNumbersLabel;  // 已查看数量

@property (nonatomic, strong) UILabel * hitTitleLabel; // 命中描述
@property (nonatomic, strong) UIButton * hitImageView; // 红？黑

@property (nonatomic, strong) UIButton * ingButton; // 未开始？进行中

/**
 数据绑定
 */
@property (nonatomic) id dataObj;

// 静态控件高度
+(CGFloat)staticHeight;

@end
