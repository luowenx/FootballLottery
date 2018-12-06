//
//  LQFollowVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAllVC.h"
#import "LQAllOneVC.h"
#import "LQAllTwoVC.h"
#import "LQAllThreeVC.h"
#import "SGPagingView.h"

@interface LQAllVC ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;


@end

@implementation LQAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageView];
}

- (void)setupPageView {
    
    NSArray *titleArr = @[@"所有专家", @"盈利榜", @"人气榜"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor blackColor];
    configure.titleSelectedColor = [UIColor redColor];
    configure.indicatorColor = [UIColor redColor];
    configure.indicatorAdditionalWidth = 100;

    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    LQAllOneVC *oneVC = [[LQAllOneVC alloc] init];
    LQAllTwoVC *twoVC = [[LQAllTwoVC alloc] init];
    LQAllThreeVC *threeVC = [[LQAllThreeVC alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(self.pageTitleView.frame) - kLQTabarHeight -kLQNavANDStatusBarHeight;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end
