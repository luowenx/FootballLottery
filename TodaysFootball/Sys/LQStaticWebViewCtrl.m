//
//  LQStaticWebViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/2.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQStaticWebViewCtrl.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKNavigationDelegate.h>

@interface LQStaticWebViewCtrl ()

@end

@implementation LQStaticWebViewCtrl


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showWebTitle) {
        RAC(self, title) = [RACObserve(self.webView, title) skip:1];
    }
}


-(void) showWebView
{
    self.webView.hidden = NO;
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [super webView:webView didStartProvisionalNavigation:navigation];
    webView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];
//    NSString *doc = @"document.body.outerHTML";
    NSMutableString *html5 = [NSMutableString string];
    [html5 appendString:@"var nouseTitle = document.getElementsByClassName(\"title\")[0];"];
    [html5 appendString:@"nouseTitle.parentNode.removeChild(nouseTitle);"];
    
    [webView evaluateJavaScript:html5 completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        [self performSelector:@selector(showWebView) withObject:nil afterDelay:.2];
    }];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFailProvisionalNavigation:navigation];
}


@end
