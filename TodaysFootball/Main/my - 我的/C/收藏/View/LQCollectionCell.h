//
//  LQCollectionCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的收藏、我的订单 cell
 */
@class LQMatchShowView2, LQBeanView;
@interface LQCollectionCell : UITableViewCell
//  头像
@property (nonatomic, strong) LQAvatarView * avatarView;
// 姓名
@property (nonatomic, strong) UILabel * nameLable;
// 描述
@property (nonatomic, strong) UILabel * sloganLabel;
// 标题
@property (nonatomic, strong) UILabel * titleLabel;
// 比赛视图
@property (nonatomic, strong) LQMatchShowView2 *matchView;
// 收藏时间
@property (nonatomic, strong) UILabel * collectionLabel;
// 购买时间
@property (nonatomic, strong) UILabel * payTimeLabel;
// 战绩标题
@property (nonatomic, strong) UILabel * hitRollLabel;
// 是否命中
@property (nonatomic, strong) UIButton * hitRollBtn;
// 比赛状态
@property (nonatomic, strong) UILabel * matchStatusLabel;

// 彩豆
@property (nonatomic, strong) LQBeanView * beanView;

@property (nonatomic, strong) UILabel * publishTimeLabel; // 时间
@property (nonatomic, strong) LQBeanView * priceBeanView;  // 彩豆
@property (nonatomic, strong) UILabel * lookLabel; // 查看
@property (nonatomic, strong) UILabel * lookNumbersLabel;  // 已查看数量


/**
 数据绑定
 */
@property (nonatomic) id dataObj;

/**
 专家详情
 */
@property (nonatomic, copy) void (^lookExpert)(id dataObj);

+(CGFloat)staticHeight;

@end
