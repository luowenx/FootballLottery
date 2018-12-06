//
//  LQStaticWebViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/2.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQWebViewCtrl.h"

/**
 *  静态web页面
 *  隐藏掉了web页自己的导航栏
 */
@interface LQStaticWebViewCtrl : LQWebViewCtrl

/**
 是否显示web页标题
 */
@property (nonatomic) BOOL showWebTitle;

@end
