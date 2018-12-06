//
//  LQHomeMainTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQBeanView.h"

/**
  主页专家推荐cell
 */
@interface LQHomeMainTableViewCell : UITableViewCell

@property (nonatomic, strong) LQAvatarView *avatarView;// 头像
@property (nonatomic, strong) UILabel * expertNameLabel; // 专家名称
@property (nonatomic, strong) UILabel * expertDescriptionLabel;  // 专家描述
@property (nonatomic, strong) UILabel * scheduleLable;  //战绩进度
@property (nonatomic, strong) UILabel * straightLabel;   // 连胜
@property (nonatomic, strong) UILabel * hitRateLabel;   //  100%
@property (nonatomic, strong) UILabel * hitDesLabel;   //命中率
@property (nonatomic, strong) UILabel * titleLabel;  // 标题
@property (nonatomic, strong) UILabel * matchLabel;  // 赛事（欧冠）
@property (nonatomic, strong) UIView *matchView; //比赛背景视图
@property (nonatomic, strong) UILabel * ranksLeftLabel;   // 左边队伍
@property (nonatomic, strong) UILabel *VSLabel;
@property (nonatomic, strong) UILabel * ranksRightLabel;   // 右边队伍
@property (nonatomic, strong) UILabel * scoreLabel;   // 比分
@property (nonatomic, strong) UILabel * timeLabel; // 时间
@property (nonatomic, strong) LQBeanView * beanView;  // 彩豆
@property (nonatomic, strong) UIButton * lookButton; // 查看
@property (nonatomic, strong) UILabel * lookNumbersLabel;  // 已查看数量

@property (nonatomic, strong) UIView *timeLine; // 时间与彩豆之间的线条

@property (nonatomic, strong) UIImageView * signView; //
@property (nonatomic, strong) UIImageView * cornerView; // 

/**
 绑定数据
 */
@property (nonatomic, strong) id  dataObj;

/**
 头像事件
 */
@property (nonatomic, copy) void (^persobAction)(id dataObj);

/**
 方案详情
 */
@property (nonatomic, copy) void (^programmeAction)(id dataObj);

/**
 比赛详情
 */
@property (nonatomic, copy) void (^matchAction)(id dataObj);

// 静态控件高度
+(CGFloat)staticHeight;

@end
