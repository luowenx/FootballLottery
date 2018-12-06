//
//  LQWebViewHyperLinkResponder.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQWebViewHyperLinkResponder.h"
#import "WebViewJSBridge.h"

#import "LQStaticWebViewCtrl.h"

@implementation LQWebViewHyperLinkResponder
@synthesize JSBridge, callback;

- (void)dealloc
{
    NSLog(@"%@ did dealloc!", NSStringFromClass(self.class));
}

- (NSString *)api
{
    return @"com.lequwuxian.lotterywinner.hyperLink";
}

-(void)receiveJSCalling:(NSDictionary *)data
{
    NSLog(@"%@", data);
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSString *url = data[@"url"];
    LQStaticWebViewCtrl *webViewCtrl = [[LQStaticWebViewCtrl alloc] init];
    webViewCtrl.title = data[@"title"]?:@"赔率详情";
    webViewCtrl.requestURL = url;
    [self.linkViewCtrl.navigationController pushViewController:webViewCtrl animated:YES];
}


@end
