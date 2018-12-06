//
//  LQWebViewCloseResponder.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/26.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQWebViewJSResponder.h"


/**
 关闭页面
 */
@class LQBaseViewCtrl;
@interface LQWebViewCloseResponder : NSObject<LQWebViewJSResponder>

@property (nonatomic, weak) LQBaseViewCtrl *viewCtrl;

@end
