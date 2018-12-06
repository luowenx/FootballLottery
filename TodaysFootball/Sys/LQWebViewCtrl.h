//
//  LQWebViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"
#import <WebKit/WebKit.h>

/**
 base web  view ctrl
 */
NS_ASSUME_NONNULL_BEGIN

@class WKNavigation, WKWebView;
@interface LQWebViewCtrl : LQBaseViewCtrl

@property (nonatomic, strong, readonly) WKWebView * webView;

@property (nonatomic, copy) NSString * _Nullable requestURL;

/**顶部、底部空隙 默认为0.0 */
- (CGFloat)topOffset;
- (CGFloat)bottomOffset;

- (void)webView:(WKWebView *_Nullable)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *_Nullable)webView didFinishNavigation:(WKNavigation *_Nullable)navigation;
- (void)webView:(WKWebView *_Nullable)webView didFailProvisionalNavigation:(WKNavigation *_Nullable)navigation;

@end

NS_ASSUME_NONNULL_END
