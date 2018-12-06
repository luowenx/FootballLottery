//
//  AppDelegate+UI.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "LQRootViewCtrl.h"

@implementation AppDelegate (UI)

#pragma mark  UI

- (void)initWindow
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    BOOL mark=[userDefaults boolForKey:@"isFirstDZS"];
    
    if (!mark) {
        self.window.rootViewController=[[FirstViewController alloc] init];
        [userDefaults setBool:YES forKey:@"isFirstDZS"];
    }else{
    LQRootViewCtrl *rootViewCtrl = [[LQRootViewCtrl alloc] init];
    [self.window setRootViewController:rootViewCtrl];
    }
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [UITableView appearance].estimatedRowHeight =0 ;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
    }
}

-(void)coverMaskView
{
    [self recoverMaskView];
    self.maskView = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.barStyle = UIBarStyleBlackTranslucent;

    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

-(void)recoverMaskView
{
    if (self.maskView) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
}


@end
