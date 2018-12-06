//
//  LQJSBridgeWebViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/26.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQJSBridgeWebViewCtrl.h"
#import "LQWebViewJSDispatchBridge.h"
#import "LQWebViewCloseResponder.h"
@interface LQJSBridgeWebViewCtrl ()

@property (nonatomic, strong) LQWebViewJSDispatchBridge *JSBridge;

@end

@implementation LQJSBridgeWebViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.JSBridge = [LQWebViewJSDispatchBridge bridgeWebView:self.webView];
    
    LQWebViewCloseResponder *closeRes = [[LQWebViewCloseResponder alloc] init];
    closeRes.viewCtrl = self;
    
    [self.JSBridge addJSResponder:closeRes];
}

-(void)onBack
{
    [self.JSBridge removeAllJSResponder];
    self.JSBridge = nil;
    [super onBack];
}

-(void)dealloc
{
    [self.JSBridge removeAllJSResponder];
    self.JSBridge = nil;
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [super webView:webView didStartProvisionalNavigation:navigation];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFailProvisionalNavigation:navigation];
}


@end
