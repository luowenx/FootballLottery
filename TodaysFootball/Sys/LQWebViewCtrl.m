//
//  LQWebViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQWebViewCtrl.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKNavigationDelegate.h>

@interface LQWebViewCtrl ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation LQWebViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
    
    [RACObserve(self.webView.scrollView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"网页滚动 -- > %@", @([x CGPointValue].y));
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)initUI
{
    self.navigationController.navigationBar.hidden = NO;
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc] init];
    configuretion.preferences = [[WKPreferences alloc]init];
    configuretion.preferences.minimumFontSize = 10;
    configuretion.preferences.javaScriptEnabled = true;
    configuretion.processPool = [[WKProcessPool alloc]init];
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuretion];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.allowsBackForwardNavigationGestures =YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.webView];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.topOffset];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:self.bottomOffset];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    self.progressView = [UIProgressView newAutoLayoutView];
    self.progressView.progressTintColor = [UIColor flsMainColor2];
    self.progressView.trackTintColor = [UIColor flsSpaceLineColor];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.topOffset];
    [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.progressView autoSetDimension:ALDimensionHeight toSize:2];
    
    @weakify(self)
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self)
        self.progressView.progress = [x doubleValue];
        if (self.progressView.progress == 1) {
            [UIView animateWithDuration:0.25f delay:0.3f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }
    }];
}

- (void)setRequestURL:(NSString *)requestURL {
    [self willChangeValueForKey:@"requestURL"];
    _requestURL = requestURL;
    [self didChangeValueForKey:@"requestURL"];
    [self initData];
}

- (void)initData {
    if (self.requestURL.length == 0) {
        return;
    }
    
    if (!lq_NetReachable()) {
        [LQJargon hiddenJargon:@"无法连接到网络"];
        [self showEmptyViewInView:self.view imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
        return;
    }
    
    //load
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.requestURL]];
    [self.webView loadRequest:request];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    [self initData];
}

-(CGFloat)topOffset
{
    return 0.0;
}

- (CGFloat)bottomOffset
{
    return 0.0;
}

#pragma mark # WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = YES;
    [self hiddenEmptyView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = YES;
    [self showEmptyViewInView:self.view imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark -
#pragma mark # WKUIDelegate
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//
//}



@end
