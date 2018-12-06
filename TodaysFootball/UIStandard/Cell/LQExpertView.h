//
//  LQExpertView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/29.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQAvatarView.h"
/**
 用户头像展示模块儿
 */
@interface LQExpertView : UIView
// 头像
@property (nonatomic, strong) LQAvatarView *avaterView;

// 姓名
@property (nonatomic, strong) UILabel *nameLabel;

// 描述
@property (nonatomic, strong) UILabel *describeLabel;

@end
