//
//  LQMatTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/1.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQBeanView.h"

/**
 比赛详情- -方案列表
 */
@interface LQMatTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) LQAvatarView *avatarView;// 头像
@property (nonatomic, strong, readonly) UILabel * expertNameLabel; // 专家名称
@property (nonatomic, strong, readonly) UILabel * expertDescriptionLabel;  // 专家描述
//@property (nonatomic, strong) UILabel * scheduleLable;  //战绩进度
@property (nonatomic, strong, readonly) UILabel * straightLabel;   // 连胜
@property (nonatomic, strong, readonly) UILabel * hitRateLabel;   //  100%
@property (nonatomic, strong, readonly) UILabel * hitDesLabel;   //命中率
@property (nonatomic, strong, readonly) UILabel * titleLabel;  // 标题
@property (nonatomic, strong, readonly) UILabel * timeLabel; // 时间

@property (nonatomic, strong, readonly) LQBeanView * beanView; // 彩豆个数
@property (nonatomic, strong, readonly) UIButton * lookButton; // 查看
@property (nonatomic, strong, readonly) UILabel * lookNumbersLabel;  // 已查看数量
// 是否命中
@property (nonatomic, strong, readonly) UIButton * hitRollBtn;
// 比赛状态
@property (nonatomic, strong, readonly) UILabel * matchStatusLabel;


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

+(CGFloat)staticHeight;

@end

