//
//  LQRootViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQRootViewCtrl.h"
#import "LQHomeVC.h"
#import "LQExpertVC.h"
#import "LQMatchVC.h"
#import "LQMyVC.h"
#import "LQMatchAllFollowVC.h"
#import "LQInformationViewCtrl.h"

#import "LQNavigationCtrl.h"
#import "LQAppConfiger.h"
#import "LQOptionManager.h"

@interface LQRootViewCtrl ()

@property (nonatomic, strong) LQNavigationCtrl * homeViewCtrl;
@property (nonatomic, strong) LQNavigationCtrl * expertViewCtrl;
@property (nonatomic, strong) LQNavigationCtrl * matchViewCtrl;
@property (nonatomic, strong) LQNavigationCtrl * mineViewCtrl;
@property (nonatomic, strong) LQNavigationCtrl * informationViewCtrl;

@end

@implementation LQRootViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.backgroundImage = [UIImage imageFromColor:[UIColor whiteColor]];
    
    // 更新检查
    [[LQAppConfiger shareInstance] versionCheck];
    
    @weakify(self)
    [[RACObserve([LQAppConfiger shareInstance], appStatus) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [self setViewControllers:@[self.homeViewCtrl, self.expertViewCtrl, self.matchViewCtrl, self.informationViewCtrl, self.mineViewCtrl] animated:YES];
            [self setSelectedIndex:0];
            // 校验订单
            [LQOptionManager checkOrder];
        }else{
            [self setViewControllers:@[self.matchViewCtrl, self.informationViewCtrl, self.mineViewCtrl] animated:YES];
            [self setSelectedIndex:0];
        }
    }];
}

#pragma mark  ===getter

-(LQNavigationCtrl *)homeViewCtrl
{
    if (!_homeViewCtrl) {
        LQHomeVC *homeViewCtrl = [[LQHomeVC alloc] init];
        homeViewCtrl.tabBarItem.title = @"首页";
        homeViewCtrl.tabBarItem.image = imageWithName(@"首页黑");
        homeViewCtrl.tabBarItem.selectedImage = [imageWithName(@"首页红") imageWithRenderingMode:YES];
        [homeViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flsMainColor]} forState:UIControlStateSelected];
        [homeViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa1a1a1)} forState:UIControlStateNormal];
        
        _homeViewCtrl = [[LQNavigationCtrl alloc] initWithRootViewController:homeViewCtrl];
    }
    return _homeViewCtrl;
}

-(LQNavigationCtrl *)expertViewCtrl
{
    if (!_expertViewCtrl) {
        LQExpertVC *expertViewCtrl = [[LQExpertVC alloc] init];
        expertViewCtrl.tabBarItem.title = @"专家";
        expertViewCtrl.tabBarItem.image = imageWithName(@"专家黑");
        expertViewCtrl.tabBarItem.selectedImage = [imageWithName(@"专家红") imageWithRenderingMode:YES];
        [expertViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flsMainColor]} forState:UIControlStateSelected];
        [expertViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa1a1a1)} forState:UIControlStateNormal];
        _expertViewCtrl = [[LQNavigationCtrl alloc] initWithRootViewController:expertViewCtrl];
    }
    return _expertViewCtrl;
}

-(LQNavigationCtrl *)matchViewCtrl
{
    if (!_matchViewCtrl) {
        LQMatchAllFollowVC *matchViewCtrl = [[LQMatchAllFollowVC alloc] init];
        matchViewCtrl.tabBarItem.title = @"赛事";
        matchViewCtrl.tabBarItem.image = imageWithName(@"赛事黑");
        matchViewCtrl.tabBarItem.selectedImage = [imageWithName(@"赛事红") imageWithRenderingMode:YES];
        [matchViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flsMainColor]} forState:UIControlStateSelected];
        [matchViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa1a1a1)} forState:UIControlStateNormal];
        _matchViewCtrl = [[LQNavigationCtrl alloc] initWithRootViewController:matchViewCtrl];

    }
    return _matchViewCtrl;
}

-(LQNavigationCtrl *)mineViewCtrl
{
    if (!_mineViewCtrl) {
        LQMyVC *mineViewCtrl = [[LQMyVC alloc] init];
        mineViewCtrl.tabBarItem.title = @"我的";
        mineViewCtrl.tabBarItem.image = imageWithName(@"我的黑");
        mineViewCtrl.tabBarItem.selectedImage = [imageWithName(@"我的红") imageWithRenderingMode:YES];
        [mineViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flsMainColor]} forState:UIControlStateSelected];
        [mineViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa1a1a1)} forState:UIControlStateNormal];
        _mineViewCtrl = [[LQNavigationCtrl alloc] initWithRootViewController:mineViewCtrl];
    }
    return _mineViewCtrl;
}


-(LQNavigationCtrl *)informationViewCtrl
{
    if (!_informationViewCtrl) {
        LQInformationViewCtrl *informationViewCtrl = [[LQInformationViewCtrl alloc] init];
        informationViewCtrl.tabBarItem.title = @"资讯";
        informationViewCtrl.tabBarItem.image = imageWithName(@"tabar_information_dark");
        informationViewCtrl.tabBarItem.selectedImage = [imageWithName(@"tabar_information_light") imageWithRenderingMode:YES];
        [informationViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flsMainColor]} forState:UIControlStateSelected];
        [informationViewCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa1a1a1)} forState:UIControlStateNormal];
        _informationViewCtrl = [[LQNavigationCtrl alloc] initWithRootViewController:informationViewCtrl];
    }
    return _informationViewCtrl;
}

@end
