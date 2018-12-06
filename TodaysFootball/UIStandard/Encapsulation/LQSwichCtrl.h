//
//  LQSwichCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 swich 视图
 */
@interface LQSwichCtrl : UIControl

/**
 当前开关状态
 */
@property (nonatomic) BOOL on;

/**
 刷新 标题

 @param onTitle 开
 @param offTitle 关
 */
-(void)updateSwithOnTitle:(NSString *)onTitle offTitle:(NSString *)offTitle;


/**
 切换开关
 */
@property (nonatomic, copy) void (^swichAction)(BOOL isOn);


@end
