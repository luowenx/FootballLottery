//
//  WebViewJSBridge.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LQJSBridgeDelegate <JSExport>

/**
 JS调用OC统一入口
 
 @param json 调用参数的json字符串
 */
- (void)call:(NSString *)json;

/** 桥接对象的版本， 暂时忽略掉 */
- (NSString *)version;

@end

@protocol LQJSBridge <NSObject>

/**
 回调给 JS
 
 @param jsMethodName JS 方法名
 @param data 参数的 JSON 字符串
 */
- (void)callbackToJS:(NSString *)jsMethodName args:(NSDictionary *)data;

@end

/**
 JS 与OC的桥接对象
 */
@interface WebViewJSBridge : NSObject<LQJSBridgeDelegate, LQJSBridge, UIWebViewDelegate, WKNavigationDelegate, WKScriptMessageHandler>{
@protected
//    /** 由于 WKWebView 的实现方式原因, 桥接对象的版本号可能会丢失, 所以需要回调 JS 时进行更新 */
//    NSString *_WKWebViewUpdateBridgeVersionJSScript;
}

@property (nonatomic, weak, readonly) __kindof WKWebView *webView;

/** WKNavigationDelegate */
@property (nonatomic, weak, nullable) id<WKNavigationDelegate> WKNavigationDelegate;

///** 是否是 成功注入 */
//@property (nonatomic) BOOL injectionSuccess;

/**
 初始化

 @param webView WKWebView
 @return self
 */
+ (instancetype)bridgeWebView:(__kindof WKWebView *)webView;

/** 不再使用桥接对象时调用 */
- (void)stopBridge NS_REQUIRES_SUPER;

/** subclass hook */
- (void)injectJavascript NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
