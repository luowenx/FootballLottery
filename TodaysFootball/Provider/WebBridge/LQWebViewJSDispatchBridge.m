//
//  LQWebViewJSDispatchBridge.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQWebViewJSDispatchBridge.h"
#import "LQWebViewJSResponder.h"

NSString * const kLQJSArgumentAPI = @"api";
NSString * const kLQJSArgumentCallback = @"callback";
NSString * const kLQJSArgumentData = @"data";

@interface LQWebViewJSDispatchBridge()

/** 所有的JS消息接收者 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LQWebViewJSResponder>> *responders;

@end

@implementation LQWebViewJSDispatchBridge

- (void)stopBridge {
    [self removeAllJSResponder];
    [super stopBridge];
}

- (void)addJSResponder:(id<LQWebViewJSResponder>)jsResponder {
    self.responders[jsResponder.api] = jsResponder;
    jsResponder.JSBridge = self;
}

- (void)removeJSResponder:(id<LQWebViewJSResponder>)jsResponder {
    [self.responders removeObjectForKey:jsResponder.api];
}

- (void)removeAllJSResponder {
    [self.responders removeAllObjects];
}

- (NSMutableDictionary<NSString *, id<LQWebViewJSResponder>> *)responders {
    if (!_responders) {
        _responders = [NSMutableDictionary new];
    }
    return _responders;
}

- (void)call:(NSString *)json {
    NSDictionary *dic = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)json.copy;
    }else{
        dic = json.jsonValue;
    }
    NSString *api = dic[kLQJSArgumentAPI];
    NSString *callback = dic[kLQJSArgumentCallback];
    NSDictionary *data = dic[kLQJSArgumentData];
    
    id<LQWebViewJSResponder> responder = self.responders[api];
    responder.callback = callback;
    
    // 由于JS 是在背景线程, 所以需要回调到主线程中处理相关事务.
    dispatch_async(dispatch_get_main_queue(), ^{
        [responder receiveJSCalling:data];
    });
}

- (NSString *)version {
    return @"1.0";
}

@end
