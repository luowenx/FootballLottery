//
//  LQModifyTextViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"

/**
 文本修改控制器
 */
@interface LQModifyTextViewCtrl : LQBaseViewCtrl

/**
 初始文本
 */
@property (nonatomic, copy) NSString * initialText;

/**
 提交成功回调
 */
@property (nonatomic, copy) void (^save)(NSString *text);

@end
