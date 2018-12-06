//
//  LQWebViewJSDispatchBridge.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "WebViewJSBridge.h"

/**
 *  OC-JS 交互接口分发
 */
@protocol LQWebViewJSResponder;
@interface LQWebViewJSDispatchBridge : WebViewJSBridge

- (void)addJSResponder:(id<LQWebViewJSResponder>)jsResponder;

- (void)removeJSResponder:(id<LQWebViewJSResponder>)jsResponder;

- (void)removeAllJSResponder;

@end
