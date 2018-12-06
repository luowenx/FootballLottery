//
//  LQExpertVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpertVC.h"
#import "LQFollowVC.h"
#import "LQAllVC.h"
#import "LQFollowTableViewCell.h"
#import "LQProgrammeDetailsVC.h"

@interface LQExpertVC ()
@property (nonatomic, strong) LQFollowVC *followVC;
@property (nonatomic, strong) LQAllVC *allVC;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign) NSInteger index;

@end

@implementation LQExpertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setupSegment];
    self.navigationController.navigationBar.barTintColor = [UIColor flsMainColor];
    self.navigationController.navigationBar.translucent = NO;

    self.followVC = [[LQFollowVC alloc] init];
    self.followVC.view .frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.followVC];

    self.allVC = [[LQAllVC alloc] init];
    self.allVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:self.followVC.view];
    self.currentVC = self.followVC;
    
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UISegmentedControl *)setupSegment{
    NSArray *items = @[@"关注", @"全部"];
    UISegmentedControl *sgc = [[UISegmentedControl alloc] initWithItems:items];
    sgc.tintColor = [UIColor whiteColor];
    
    if (mt_iPhone4 || mt_iPhone5) {
        [sgc setWidth:60 forSegmentAtIndex:0];
        [sgc setWidth:60 forSegmentAtIndex:1];
        NSDictionary *dic = @{
                              //1.设置字体样式:例如黑体,和字体大小
                              NSFontAttributeName:[UIFont systemFontOfSize:11]};
        [sgc setTitleTextAttributes:dic forState:UIControlStateNormal];
    }else if (mt_iPhone6 || is_iPhoneX) {
        [sgc setWidth:70 forSegmentAtIndex:0];
        [sgc setWidth:70 forSegmentAtIndex:1];
    }else if (mt_iPhone6_Plus) {
        [sgc setWidth:80 forSegmentAtIndex:0];
        [sgc setWidth:80 forSegmentAtIndex:1];
    }
    
    //默认选中的位置
    sgc.selectedSegmentIndex = 0;
    //监听点击
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    return sgc;
}

- (void)segmentChange:(UISegmentedControl *)sgc{
    self.index = sgc.selectedSegmentIndex;
    switch (sgc.selectedSegmentIndex) {
        case 0:
            [self replaceFromOldViewController:self.allVC toNewViewController:self.followVC];
            break;
        case 1:
            [self replaceFromOldViewController:self.followVC toNewViewController:self.allVC];
            break;
        default:
            break;
    }
}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}


@end
