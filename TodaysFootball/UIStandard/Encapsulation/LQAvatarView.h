//
//  LQAvatarView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LQAvatarViewGrade) {  // 外圈宽度档次
    kLQAvatarViewGradeMini = 1,      //  0.5 pt
    kLQAvatarViewGradeSmall,    // 1
    kLQAvatarViewGradeNomal,  //  1.5
    kLQAvatarViewGradeLarge,  //  2
    kLQAvatarViewGradeSuper,  //  2.5
};

/**
 *  有框儿的头像视图
 *  内部有size 约束、圆角设置
 */
@interface LQAvatarView : UIView

@property (nonatomic, strong) UIImageView * avatarImageView;

/**
 带圈儿的头像

 @param length 边长
 @param grade 外圈儿宽度等级
 @return self
 */
-(instancetype)initWithLength:(CGFloat)length grade:(LQAvatarViewGrade)grade;


/**
 *  ringWidth  自定义圈儿的宽度
 */
-(instancetype)initWithLength:(CGFloat)length ringWidth:(CGFloat)ringWidth;

@end
