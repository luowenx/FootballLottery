//
//  LQInputBox.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 输入框
 * 注意布局请设置 bottomCons，不用设置高度
 */
@interface LQInputBox : UIView

@property (nonatomic, strong) NSLayoutConstraint *bottomCons;

@property (nonatomic, copy) NSString *placeholder;

/**
 当前文本
 */
@property (nonatomic, strong, readonly) NSString *text;

/**
 发送回调
 */
@property (nonatomic, copy) void (^send)(NSString *text);

/**
 右边按钮回调
 */
@property (nonatomic, copy) void (^comment)(void);

/**
 弹出键盘的时候调用

 @param keyboardFrame 键盘frame
 */
- (void)annimationWithKeyboardFrame:(CGRect)keyboardFrame;
/**
 收回键盘
 */
-(void)hiddenBox;

@end
