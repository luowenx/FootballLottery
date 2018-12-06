//
//  LQMatchStatusWebView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMatchStatusWebView.h"
#import <WebKit/WebKit.h>

@interface LQMatchStatusWebView ()<WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic) BOOL successed;

@end

@implementation LQMatchStatusWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc] init];
        configuretion.preferences = [[WKPreferences alloc]init];
        configuretion.preferences.minimumFontSize = 10;
        configuretion.preferences.javaScriptEnabled = true;
        configuretion.processPool = [[WKProcessPool alloc]init];
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuretion];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.allowsBackForwardNavigationGestures =YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.allowsBackForwardNavigationGestures = NO;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_webView];
        
        [_webView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_webView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_webView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_webView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
    }
    return self;
}

-(void)setUrlStrl:(NSString *)urlStrl
{
    if ([urlStrl isEqualToString:_urlStrl] && self.successed) {
        return;
    }
    _urlStrl = urlStrl;
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStrl]];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self showActivityViewWithTitle:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hiddenActivityWithTitle:nil];
    self.successed = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    self.successed = NO;
    [self hiddenActivityWithTitle:nil];
}



@end
