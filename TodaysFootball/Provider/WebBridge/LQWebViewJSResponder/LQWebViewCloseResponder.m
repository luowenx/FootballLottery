//
//  LQWebViewCloseResponder.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/26.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQWebViewCloseResponder.h"
#import "WebViewJSBridge.h"

#import "LQBaseViewCtrl.h"

@implementation LQWebViewCloseResponder
@synthesize JSBridge, callback;


- (void)dealloc
{
    NSLog(@"%@ did dealloc!", NSStringFromClass(self.class));
}

- (NSString *)api
{
    return @"com.lequwuxian.lotterywinner.close";
}

-(void)receiveJSCalling:(NSDictionary *)data
{
    [self.viewCtrl onBack];
}


@end
