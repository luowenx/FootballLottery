//
//  LQPlanDetailCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  by luowenx   、方案详情cell  (358)
 */
@class PlanTimeStatusView, PlanPlayView, __OddView, PlanAutoOddsView;
@interface LQPlanDetailCell : UITableViewCell
/*********** 时间状态  ***************/
@property (nonatomic, strong) PlanTimeStatusView * timeStatusView;

/*********** 赛况  ***************/
@property (nonatomic, strong) UILabel *concedLabel; // 让球
@property (nonatomic, strong) UILabel * concedValueLabel; //

@property (nonatomic, strong) LQAvatarView * homeIconView;    // home team icon
@property (nonatomic, strong) UILabel * homeLabel;                      // home team name
@property (nonatomic, strong) PlanPlayView * homeVictoryView; // 主胜

@property (nonatomic, strong) UILabel * flatLabel;   // 比分  VS
@property (nonatomic, strong) PlanPlayView * flatView;   // 平

@property (nonatomic, strong) LQAvatarView * guestIconView;  //  guest team icon
@property (nonatomic, strong) UILabel * guestLabel;                      // guest team name
@property (nonatomic, strong) PlanPlayView * guestVictoryView;  // 客胜

@property (nonatomic, strong) UILabel * tipsLabel1;
@property (nonatomic, strong) UIImageView * tipsImageView;
@property (nonatomic, strong) UIView * playLine1; // 主胜之间的线
@property (nonatomic, strong) UIView * playLine2;

/*********** 倍率变化  ***************/
@property (nonatomic, strong) PlanAutoOddsView * oddsView;

/**
 open the odds
 */
@property (nonatomic, copy) void (^open)(id dataObj);

/**
 查看该比赛
 */
@property (nonatomic, copy) void (^lookMatch)(id dataObj);

/**
 数据绑定
 */
@property (nonatomic) id dataObj;
@end

/*********** 时间状态  ***************/
@interface PlanTimeStatusView : UIView
@property (nonatomic, strong) UILabel * leagueLabel;
@property (nonatomic, strong) UILabel * startTimeLabel;
@property (nonatomic, strong) UIButton * statusButton;
@property (nonatomic, strong) UIView * line;
@end

/*********** 赛况  ***************/
@interface PlanPlayView : UIView
@property (nonatomic, strong) UILabel * playTitleLabel;
@property (nonatomic, strong) UILabel * playValueLabel;
@property (nonatomic, strong) UIImageView * hookImageView;
@property (nonatomic, strong) UIImageView * hitImageView;

/**
 设置背景和文字颜色

 @param outcome (0-->主胜，1-->平，2-->客胜)
 @param isRecommend 是否是推荐
 */
-(void)setOutcome:(NSInteger)outcome isRecommend:(BOOL)isRecommend;

@end

/*********** 倍率  ***************/
@class LQExtraOdds;
@interface PlanAutoOddsView : UIView

@property (nonatomic, copy) void (^selfHeight)(CGFloat height);

@property (nonatomic, getter=isOpen) BOOL open;

@property (nonatomic, strong) NSArray <LQExtraOdds*> *oddData;

-(void)reloadView;

@end

@interface __OddView : UIView
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@end


