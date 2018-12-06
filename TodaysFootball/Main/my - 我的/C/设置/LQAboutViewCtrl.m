//
//  LQAboutViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/26.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAboutViewCtrl.h"

#import "AppUtils.h"

@interface LQAboutViewCtrl ()

@end

@implementation LQAboutViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    
    UIImageView *icon = [UIImageView newAutoLayoutView];
    icon.image = imageWithName(@"appIcon60x60");
    [self.view addSubview:icon];
    [icon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:115];
    [icon autoSetDimensionsToSize:CGSizeMake(120, 120)];
    
    UILabel *label = [UILabel newAutoLayoutView];
    label.text = [AppUtils bundleName];
    [self.view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:icon withOffset:10];
}


@end
