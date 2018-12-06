//
//  LQAllTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 专家-全部 cell-1
 */
@interface LQAllTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) LQAvatarView * avatarImageView;
@property (nonatomic, strong, readonly) UILabel * nameLabel;
@property (nonatomic, strong, readonly) UILabel * sloganLabel;
@property (nonatomic, strong, readonly) UILabel * hitRollLabel;
@property (nonatomic, strong, readonly) UIButton * followButton;
// 子标题之间的线
@property (nonatomic, strong, readonly) UIView *subTitleLine;

// 第二个标题是否贴边儿
@property (nonatomic) BOOL sloganIsWelt;

/**
 绑定数据
 */
@property (nonatomic) id dataObj;

@property (nonatomic, copy) void (^follow)(id dataObj, UIButton *sender);


@end
