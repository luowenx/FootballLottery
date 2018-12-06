//
//  LQHomeVerbTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/30.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 首页头部cell
 */
@interface LQHomeVerbTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leagueLabel;
@property (nonatomic, strong) UILabel *scoreLabel; // 右边时间
@property (nonatomic, strong) UILabel *leagueTimeLabel; // 左边时间

@property (nonatomic, strong) UILabel * leftTeamLabel;
@property (nonatomic, strong) LQAvatarView * leftTeamImageView;

@property (nonatomic, strong) UILabel * VSLabel;

@property (nonatomic, strong) LQAvatarView * rightTeamImageView;
@property (nonatomic, strong) UILabel * rightTeamLabel;


@end
