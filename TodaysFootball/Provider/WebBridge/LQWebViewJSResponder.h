//
//  LQWebViewJSResponder.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LQJSBridge;
@protocol LQWebViewJSResponder <NSObject>

- (void)receiveJSCalling:(NSDictionary *)data;

@property (nonatomic, copy, readonly) NSString *api;

@property (nonatomic, copy) NSString *callback;

@property (nonatomic, weak) id<LQJSBridge> JSBridge;

@end
