//
//  LQMatchAllFollowVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchAllFollowVC.h"
#import "LQMatchFollowVC.h"
#import "LQSiftOutVC.h"
#import "LQMatchAllOne.h"
#import "LQMatchAllTwo.h"
#import "LQMatchAllThree.h"
#import "SGPagingView.h"
#import "LQFilterConfiger.h"
#import "AppUtils.h"

@interface LQMatchAllFollowVC ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@property (nonatomic, strong) LQMatchAllOne *immediateViewCtrl;
@property (nonatomic, strong) LQMatchAllTwo *resultViewCtrl;
@property (nonatomic, strong) LQMatchAllThree *scheduleViewCtrl;
@property (nonatomic, strong) LQMatchFollowVC *followViewCtrl;

@property (nonatomic, strong) LQFilterConfiger *immediateFilter;
@property (nonatomic, strong) LQFilterConfiger *resultFilter;
@property (nonatomic, strong) LQFilterConfiger *scheduleFilter;

@end

@implementation LQMatchAllFollowVC
{
    UIButton *rightBtn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = [AppUtils bundleName];
    
    [self setupPageView];
    
    @weakify(self)
    _immediateViewCtrl.filterData = ^(BOOL filter, NSInteger count) {
        if(filter){
            [self_weak_.pageTitleView resetTitleWithIndex:0 newTitle:[NSString stringWithFormat:@"即时(%@)", @(count)]];
        }else{
            [self_weak_.pageTitleView resetTitleWithIndex:0 newTitle:@"即时"];
        }
    };
    
    _resultViewCtrl.filterData = ^(BOOL filter, NSInteger count) {
        if(filter){
            [self_weak_.pageTitleView resetTitleWithIndex:1 newTitle:[NSString stringWithFormat:@"赛果(%@)", @(count)]];
        }else{
            [self_weak_.pageTitleView resetTitleWithIndex:1 newTitle:@"赛果"];
        }
    };
    
    _scheduleViewCtrl.filterData = ^(BOOL filter, NSInteger count) {
        if(filter){
            [self_weak_.pageTitleView resetTitleWithIndex:2 newTitle:[NSString stringWithFormat:@"赛程(%@)", @(count)]];
        }else{
            [self_weak_.pageTitleView resetTitleWithIndex:2 newTitle:@"赛程"];
        }
    };
    
    rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 28, 12, 0);
    [rightBtn setImage:imageWithName(@"screening") forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(onClickedOKbtn) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationController.navigationBar.barTintColor = [UIColor flsMainColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupPageView {
    NSArray *titleArr = @[@"即时", @"赛果", @"赛程", @"关注"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor blackColor];
    configure.titleSelectedColor = [UIColor flsMainColor];
    configure.indicatorColor = [UIColor flsMainColor];
    configure.indicatorAdditionalWidth = 100;
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    _immediateViewCtrl = [[LQMatchAllOne alloc] init];
    _resultViewCtrl = [[LQMatchAllTwo alloc] init];
    _scheduleViewCtrl = [[LQMatchAllThree alloc] init];
    _followViewCtrl = [[LQMatchFollowVC alloc] init];
    NSArray *childArr = @[_immediateViewCtrl, _resultViewCtrl, _scheduleViewCtrl, _followViewCtrl];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame) - kLQTabarHeight -kLQNavANDStatusBarHeight;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    _pageTitleView.selectedIndex = selectedIndex;
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    rightBtn.hidden = (selectedIndex == 3);
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    if(progress>=1){
        _pageTitleView.selectedIndex = targetIndex;
        rightBtn.hidden = (targetIndex == 3);
    }
}

- (void)onClickedOKbtn{
    LQSiftOutVC *vc = [[LQSiftOutVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.configer = self.filterConfiger;
    @weakify(self)
    vc.confirmFilter = ^(LQFilterConfiger *configer) {
        [self_weak_ setFilterConfiger:configer];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  ==== 筛选

-(void)filter
{

}

-(LQFilterConfiger *)filterConfiger
{
    if (self.pageTitleView.selectedIndex == 0) { //
        return self.immediateFilter.copy;
    }else if (self.pageTitleView.selectedIndex == 1){
        return self.resultFilter.copy;
    }else{
        return self.scheduleFilter.copy;
    }
}

-(void)setFilterConfiger:(LQFilterConfiger *)filterConfiger
{
    if (self.pageTitleView.selectedIndex == 0) {
        self.immediateFilter = filterConfiger.copy;
        [self.immediateViewCtrl filterWithLeague:self.immediateFilter.pram];
    }else if (self.pageTitleView.selectedIndex == 1){
        self.resultFilter = filterConfiger.copy;
        [self.resultViewCtrl filterWithLeague:self.resultFilter.pram];
    }else{
        self.scheduleFilter = filterConfiger.copy;
        [self.scheduleViewCtrl filterWithLeague:self.scheduleFilter.pram];
    }
}



-(LQFilterConfiger *)immediateFilter
{
    if (!_immediateFilter) {
        _immediateFilter = [[LQFilterConfiger alloc] init];
        _immediateFilter.page = 1;
    }
    return _immediateFilter;
}

-(LQFilterConfiger *)resultFilter
{
    if (!_resultFilter) {
        _resultFilter = [[LQFilterConfiger alloc] init];
        _resultFilter.page = 2;
    }
    return _resultFilter;
}

-(LQFilterConfiger *)scheduleFilter
{
    if (!_scheduleFilter) {
        _scheduleFilter = [[LQFilterConfiger alloc] init];
        _scheduleFilter.page = 3;
    }
    return _scheduleFilter;
}
@end

