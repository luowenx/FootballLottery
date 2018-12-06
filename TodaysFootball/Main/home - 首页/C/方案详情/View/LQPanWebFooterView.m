//
//  LQPanWebFooterView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/12.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQPanWebFooterView.h"

@interface LQPlanWebFooterView()<UIWebViewDelegate>
@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UILabel * tipsLabel;
@end

@implementation LQPlanWebFooterView
{
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topLine = [UIView newAutoLayoutView];
        self.topLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:self.topLine];
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.topLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.topLine autoSetDimension:ALDimensionHeight toSize:4];
        
        UILabel *reasonLabel = [UILabel newAutoLayoutView];
        reasonLabel.text = @"推荐理由：";
        reasonLabel.font = [UIFont lqsFontOfSize:34];
        reasonLabel.textColor = UIColorFromRGB(0x393939);
        [self addSubview:reasonLabel];
        [reasonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_topLine withOffset:15];
        [reasonLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
        
        self.tipsLabel = [UILabel newAutoLayoutView];
        self.tipsLabel.textColor = UIColorFromRGB(0xa2a2a2);
        self.tipsLabel.backgroundColor = UIColorFromRGB(0xf2f2f2);
        self.tipsLabel.font = [UIFont lqsFontOfSize:20];
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.text = @"观点建议仅供参考，投注需谨慎 ！";
        [self addSubview:self.tipsLabel];
        [self.tipsLabel autoSetDimension:ALDimensionHeight toSize:25];
        [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        self.webView = [UIWebView newAutoLayoutView];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = NO;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.webView];
        [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.webView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:reasonLabel withOffset:10];
        [self.webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tipsLabel withOffset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
    }
    return self;
    
}
-(void)loadWithHTMLString:(NSString*)HTML baseUrl:(NSURL*)url
{
    NSString *myStr = [NSString stringWithFormat:@"<head><style>img{max-    width:%f !important;}</style></head>", UIDeviceScreenWidth - 20];
    NSString *str = [NSString stringWithFormat:@"%@%@",myStr, HTML];
    [self.webView loadHTMLString:str baseURL:url];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    height = webViewHeight + 25 + 25 + [UIFont lqsFontOfSize:34].lineHeight;
    self.frame = CGRectMake(0, 0, UIDeviceScreenWidth, height);
    self.updataHeight?self.updataHeight(height):nil;
    webView.scrollView.scrollEnabled = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    height = 25 + 25 + [UIFont lqsFontOfSize:34].lineHeight;
    self.updataHeight?self.updataHeight(height):nil;
}

-(CGFloat)totalHeight
{
    return height;
}

@end
