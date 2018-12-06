//
//  LQWeekProTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 专家- 全部 cell-2
 */
@interface LQWeekProTableViewCell : UITableViewCell
@property (nonatomic, strong) LQAvatarView * avatarImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * sloganLabel;
@property (nonatomic, strong) UIButton * followButton;

@property (nonatomic) NSInteger rank;

@property (nonatomic, strong) UILabel * extensionLabel;
@property (nonatomic, strong) UIImageView * extensionIImageView;

/**
 绑定数据
 */
@property (nonatomic) id dataObj;

@property (nonatomic, copy) void (^follow)(id dataObj);

@end
