//
//  FirstViewController.m
//  MyTimer
//
//  Created by bever on 16/3/4.
//  Copyright © 2016年 123. All rights reserved.
//

#import "FirstViewController.h"
#import "LQRootViewCtrl.h"


@interface FirstViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation FirstViewController{
    UIPageControl *pageCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize=CGSizeMake(UIDeviceScreenWidth*3, UIDeviceScreenHeight);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<3; i++) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(UIDeviceScreenWidth*i, 0, UIDeviceScreenWidth, UIDeviceScreenHeight)];
        
        if (is_iPhoneX) {
            imgView.contentMode = UIViewContentModeScaleToFill;
            NSString *name = [NSString stringWithFormat:@"loading_x%d",i+1];
            imgView.image = imageNoCacheWithName(name, @"png");
        }else{
            NSString *name = [NSString stringWithFormat:@"loading_%d",i+1];
            imgView.image = imageWithName(name);
        }
        
        [_scrollView addSubview:imgView];

        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (i < 2) {
            continue;
        }
        imgView.userInteractionEnabled = YES;
        [imgView addTapGestureWithBlock:^(UIView *gestureView) {
            LQRootViewCtrl *rootVc = [[LQRootViewCtrl alloc] init];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = rootVc;
        }];
    }
    
    pageCtrl = [UIPageControl newAutoLayoutView];
    pageCtrl.numberOfPages = 3;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor flsSpaceLineColor];
    pageCtrl.currentPageIndicatorTintColor = UIColorFromRGB(0xa2a2a2);
    [self.view addSubview:pageCtrl];
    [pageCtrl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [pageCtrl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15 + (is_iPhoneX ? kLQSafeBottomHeight : -10)];
}

#pragma mark - 滑动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageCtrl.currentPage = scrollView.contentOffset.x/UIDeviceScreenWidth;
}



@end
