//
//  LequViewController.h
//  newLequSDK
//
//  Created by Mog90 on 14-9-28.
//  Copyright (c) 2014年 东荣 莫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LequLoginInfo.h"

@interface LequViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView_;
    UIActivityIndicatorView *activityIndicator;
}

@property(assign)BOOL isHidden;
//@property(assign) int webViewWidth;
//@property(assign) int webViewHeight;
//@property(assign) int screenwidth;
//@property(assign) int screenHeight;

@property(assign) BOOL hasCorner;

-(void)setView:(int)webViewWidth :(int) webViewHeight :(int) screenwidth :(int) screenHeight;
- (void)initWebView;
- (void)loadWebPageWithString:(NSString *)url;
- (void)loadWebPageWithJs:(NSString *)content;
- (void)postNotification:(NSString *)name : (NSString *)code;
- (void)receiveIap:(NSNotification *)notification;
- (void)setStatusBarBackgroundColo:(UIColor *)color;

@end
