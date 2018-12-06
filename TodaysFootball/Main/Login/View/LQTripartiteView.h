//
//  LQTripartiteView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 三方登录视图
 */
@interface LQTripartiteView : UIView

/**
 初始化方法

 @param frame 位置大小
 @param channels 登录方式
 @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame channels:(NSArray*)channels;

/**
 刷新所有按钮

 @param channels 新的登录方式
 */
- (void)updataWithChannels:(NSArray*)channels;


/**
 点击登录方式回调
 */
@property (nonatomic, copy) void (^selectedLogin)(id channel);

@end
