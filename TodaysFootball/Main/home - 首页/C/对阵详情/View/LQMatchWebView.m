//
//  LQMatchWebView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchWebView.h"
#import "LQSwichCtrl.h"
#import <WebKit/WebKit.h>
#import "LQWebViewJSDispatchBridge.h"
#import "LQWebViewHyperLinkResponder.h"

@interface LQMatchWebView() <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) LQWebViewJSDispatchBridge *JSBridge;

@property (nonatomic, strong) LQWebViewHyperLinkResponder *hyperLinkRes;

@property (nonatomic) BOOL successed;

@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation LQMatchWebView {
    NSLayoutConstraint * consWebTop;
    UIView *placeholderView_;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _swichCtrl = [LQSwichCtrl newAutoLayoutView];
        [self addSubview:_swichCtrl];
        [_swichCtrl autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_swichCtrl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        
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
        consWebTop = [_webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];

        [self initJSBridge];
    }
    return self;
}

-(void)dealloc
{
    [self clear];
}

-(void)initJSBridge
{
    self.JSBridge = [LQWebViewJSDispatchBridge bridgeWebView:_webView];
   
    self.hyperLinkRes = [[LQWebViewHyperLinkResponder alloc] init];
    self.hyperLinkRes.linkViewCtrl = self.linkViewCtrl;
    [self.JSBridge addJSResponder:self.hyperLinkRes];
}


-(void)clear
{
    [self.JSBridge removeAllJSResponder]; // 清空响应者
    [self.JSBridge stopBridge]; // 停止桥接功能
    self.JSBridge = nil;
}

-(void)hiddenSwichCtrl
{
    self.swichCtrl.hidden = YES;
    consWebTop.constant = 0;
}

-(CGFloat)swichCtrlHeight
{
    return consWebTop.constant;
}

-(void)setUrlStrl:(NSString *)urlStrl
{
    _urlStrl = urlStrl;
    
    [self reloadWebView];

}

-(void)reloadWebView
{
    [self loadUrl];
}

-(void)setLinkViewCtrl:(LQBaseViewCtrl *)linkViewCtrl
{
    _linkViewCtrl = linkViewCtrl;
    self.hyperLinkRes.linkViewCtrl = linkViewCtrl;
}

-(void)enableWebViewScrolled
{
    self.webView.scrollView.scrollEnabled = YES;
}

-(void)disEnableWebViewScrolled
{
    self.webView.scrollView.scrollEnabled = NO;
}

-(void)dispose
{
    if (_disposable && !_disposable.isDisposed) {
        [_disposable dispose];
        _disposable = nil;
    }
}

#pragma mark  web view 代理
-(void) loadUrl
{
    if (_urlStrl.length <= 0) {
        return;
    }
    
    if (!lq_NetReachable()) {
        [LQJargon hiddenJargon:@"无法连接到网络"];
        [self showEmptyViewInView:self imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
        return;
    }else{
        [self hiddenEmptyView];
    }
    
    [self dispose];
    
    @weakify(self)
    _disposable = [[RACSignal interval:5 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        
        [self_weak_ webView:self_weak_.webView didFailProvisionalNavigation:nil];
    }];
    
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
    
    if (self.judgementOffset >= 225 - kLQNavANDStatusBarHeight) {
        [self enableWebViewScrolled];
    }else{
        [self disEnableWebViewScrolled];
    }
    [self dispose];
    [self hiddenEmptyView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    self.successed = NO;
    [self hiddenActivityWithTitle:nil];
    [self dispose];
    [self showEmptyViewInView:self imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
}

#pragma mark  === empty

-(UIView *)showEmptyViewInView:(UIView *)superView imageName:(NSString *)imageName title:(NSString *)title
{
    if (!superView) {
        return nil;
    }
    [self hiddenEmptyView];
    
    placeholderView_ = [UIView newAutoLayoutView];
    [superView addSubview:placeholderView_];
    [placeholderView_ autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIImageView *imageView = [UIImageView newAutoLayoutView];
    imageView.image = imageWithName(imageName);
    [placeholderView_ addSubview:imageView];
    [imageView autoCenterInSuperview];
    [imageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
    
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.text = title;
    titleLabel.font = [UIFont lqsFontOfSize:30];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0xb2b2b2);
    [placeholderView_ addSubview:titleLabel];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView];
    
    @weakify(self)
    [placeholderView_ addTapGestureWithBlock:^(UIView *gestureView) {
        [self_weak_ hiddenEmptyView];
        [self_weak_ loadUrl];
    }];
    
    return placeholderView_;
}

- (void)hiddenEmptyView
{
    if (placeholderView_) {
        [placeholderView_ removeFromSuperview];
        placeholderView_ = nil;
    }
}

@end
