//
//  LQEditBaseViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"


typedef NS_OPTIONS(NSUInteger, LQLoginEditingSubViewOption) {
    LQLoginEditingSubViewOptionAccountNumber       = 1 << 0,
    LQLoginEditingSubViewOptionVerificationCode    = 1 << 1,
    LQLoginEditingSubViewOptionPassword            = 1 << 2,
    LQLoginEditingSubViewOptionConfirm             = 1 << 3,
};

/**
 输入框登录基类
 */
@interface LQEditBaseViewCtrl : LQBaseViewCtrl
-(instancetype)initWithSubViewOption:(LQLoginEditingSubViewOption)subViewOption;

// 控件元素
@property (nonatomic, readonly) LQLoginEditingSubViewOption subViewOption;


/* * * * * * * * * * * * * * * * * */
/* 手机号输入框 */
@property (nonatomic, strong, readonly) UITextField * phoneTextFeild;
/* 验证码输入框 */
@property (nonatomic, strong, readonly) UITextField * codeTextFeild;
/* 密码输入框 */
@property (nonatomic, strong, readonly) UITextField * passwordTextFeild;
/* 验证码按钮 */
@property (nonatomic, strong, readonly) UIButton * codeButton;
/* 确定按钮 */
@property (nonatomic, strong, readonly) UIButton * confirmButton;

/* * * * * * * * * * * * * * * * * */
/* 确定按钮事件 */
- (void)confirmAction;
/* 验证码事件 */
- (void)codeAction;
/* 文本长度限制 */
- (NSInteger)maxTextNumberTheTextFeild:(UITextField *)textField;
/* 隐藏键盘 */
- (void)hideKeyboardAction;

@end
