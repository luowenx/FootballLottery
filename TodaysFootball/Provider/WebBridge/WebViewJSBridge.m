//
//  WebViewJSBridge.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "WebViewJSBridge.h"

@implementation WebViewJSBridge {
    NSString *_JSEntrance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self->_WKWebViewUpdateBridgeVersionJSScript = [NSString stringWithFormat:@"window.webkit.version = '%@';", self.version];
        self->_JSEntrance = @"call";
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ did dealloc!", NSStringFromClass(self.class));
}

- (void)stopBridge {
    WKWebView *wk = (WKWebView *)self.webView;
    wk.navigationDelegate = self.WKNavigationDelegate;
    self.WKNavigationDelegate = nil;
    [wk.configuration.userContentController removeScriptMessageHandlerForName:self->_JSEntrance];
}

#pragma mark - JSBridgeDelegate
/** subclass hook */
- (void)call:(NSString *)json {}

- (NSString *)version
{
    NSAssert(NO, @"子类必须实现!");
    return @"";
}

#pragma mark - Public
+(instancetype)bridgeWebView:(__kindof WKWebView *)webView
{
    if (![webView isKindOfClass:[WKWebView class]]) {
        NSAssert(NO, @"webView 必须为 WKWebView 对象");
        return nil;
    }
    WebViewJSBridge *bridge = [[self alloc] init];
    bridge->_webView = webView;
    bridge.WKNavigationDelegate = webView.navigationDelegate;
    webView.navigationDelegate = bridge;
    [bridge injectJavascript];
    return bridge;
}

#pragma mark - Private
//- (void)__registerHelperJS:(WKWebView *)webView {
//    @weakify(self);
//    [webView evaluateJavaScript:self->_WKWebViewUpdateBridgeVersionJSScript
//              completionHandler:^(id a, NSError *e) {
//                  self_weak_.injectionSuccess = YES;
//                  if (e) {
//                      self_weak_.injectionSuccess = NO;
//                  }
//                  NSLog(@"a: %@----error:%@", a, e);
//              }];
//}

/** subclass hook */
- (void)injectJavascript
{
    WKWebView *wk = (WKWebView *)self.webView;
    wk.configuration.userContentController = [WKUserContentController new];
    [wk.configuration.userContentController removeScriptMessageHandlerForName:self->_JSEntrance];
    [wk.configuration.userContentController addScriptMessageHandler:self name:self->_JSEntrance];
}

- (void)callbackToJS:(NSString *)jsMethodName args:(NSDictionary *)data {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *json;
    if (jsonData.length > 0 && error == nil) {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    if (!jsMethodName || jsMethodName.length <= 0) {
        return;
    }
    NSString *jsScript = [NSString stringWithFormat:@"%@('%@');", jsMethodName, json];
//    @weakify(self);
    [self.webView evaluateJavaScript:jsScript
                                completionHandler:^(id _Nullable a, NSError * _Nullable error) {
                                    NSLog(@"a: %@----error:%@", a, error);
//                                    [self_weak_ __registerHelperJS:(self_weak_.webView];
                                }];
}

- (void)__invokeIMPFunction:(id)body name:(NSString *)name {
    SEL selector;
    BOOL isParameter = YES;
    if ([body isKindOfClass:[NSString class]]) {
        isParameter = ![body isEqualToString:@""];
    }
    if (isParameter && body) {
        selector = NSSelectorFromString([name stringByAppendingString:@":"]);
    } else {
        selector = NSSelectorFromString(name);
    }
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        if (body) {
            void (*func)(id, SEL, id) = (void *)imp;
            func(self, selector,body);
        } else {
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        }
    }
}


#pragma mark - message forwarding
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        responds = [self.WKNavigationDelegate respondsToSelector:aSelector];
    }
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id target = [super forwardingTargetForSelector:aSelector];
    if (target) {
        return target;
    }
    if ([self.WKNavigationDelegate respondsToSelector:aSelector]) {
        return self.WKNavigationDelegate;
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.WKNavigationDelegate respondsToSelector:anInvocation.selector]) {
        anInvocation.target = self.WKNavigationDelegate;
        [anInvocation invoke];
        return;
    }
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature) {
        return signature;
    }
    if ([self.WKNavigationDelegate respondsToSelector:aSelector]) {
        return [(NSObject *)self.WKNavigationDelegate methodSignatureForSelector:aSelector];
    }
    return nil;
}

/** !warning: 以下代理方法只实现业务逻辑必要的, 其余的代理方法则通过消息转发的方式转发到代理对象中 */
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [self __registerHelperJS:webView];
    if (self.WKNavigationDelegate && [self.WKNavigationDelegate respondsToSelector:_cmd]) {
        [self.WKNavigationDelegate webView:webView didFinishNavigation:navigation];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    [self __invokeIMPFunction:message.body name:message.name];
}


@end
