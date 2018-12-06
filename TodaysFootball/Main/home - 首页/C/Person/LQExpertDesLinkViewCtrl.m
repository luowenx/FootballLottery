//
//  LQExpertDesLinkViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/8.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQExpertDesLinkViewCtrl.h"

@interface LQExpertDesLinkViewCtrl ()

@end

@implementation LQExpertDesLinkViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, title) = [RACObserve(self.webView, title) skip:1];
}

- (void)webView:(WKWebView *_Nullable)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self.view showActivityViewWithTitle:@"加载中"];
}

- (void)webView:(WKWebView *_Nullable)webView didFinishNavigation:(WKNavigation *_Nullable)navigation
{
    [self.view hiddenActivityWithTitle:@""];
}

- (void)webView:(WKWebView *_Nullable)webView didFailProvisionalNavigation:(WKNavigation *_Nullable)navigation
{
    [self.view hiddenActivityWithTitle:@"加载失败"];
}


@end
