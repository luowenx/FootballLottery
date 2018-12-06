//
//  LQMatchCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 赛事cell
 */
@class LQMatchShowView;
@interface LQMatchCell : UITableViewCell
// 时间
@property (nonatomic, strong) UILabel * timeLabel;
// 状态
@property (nonatomic, strong) UILabel * statusLabel;
// 联盟
@property (nonatomic, strong) UILabel * leagueLabel;
// 比赛视图
@property (nonatomic, strong) LQMatchShowView * matchShowView;
// 战绩
@property (nonatomic, strong) UILabel * recordLabel;
// 方案个数
@property (nonatomic, strong) UILabel * planCountLabel;
@property (nonatomic, strong) UIImageView * arrowView;

+ (CGFloat) selfHeight;

-(void) cheackStatus;

@end
