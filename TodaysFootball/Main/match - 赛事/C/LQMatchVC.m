//
//  LQMatchVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchVC.h"
#import "LQMatchFollowVC.h"
#import "LQMatchAllFollowVC.h"
#import "LQSiftOutVC.h"
#import "LQFilterConfiger.h"

@interface LQMatchVC ()
@property (nonatomic, strong) LQMatchFollowVC *followVC;
@property (nonatomic, strong) LQMatchAllFollowVC *allVC;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UISegmentedControl *segmentCtrl;
@property (nonatomic, assign) NSInteger index;

@end

@implementation LQMatchVC{
    UIButton *rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)creatUI
{
    rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 28, 12, 0);
    [rightBtn setImage:imageWithName(@"screening") forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(onClickedOKbtn) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.titleView = self.segmentCtrl;
    self.navigationController.navigationBar.barTintColor = [UIColor flsMainColor];
    self.navigationController.navigationBar.translucent = NO;

    self.followVC = [[LQMatchFollowVC alloc] init];
    self.followVC.view .frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kLQTabarHeight);
    [self addChildViewController:self.followVC];
    
    self.allVC = [[LQMatchAllFollowVC alloc] init];
    self.allVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kLQTabarHeight);
    [self addChildViewController:self.allVC];

    [self.view addSubview:self.allVC.view];
    self.currentVC = self.allVC;
    
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

- (void)onClickedOKbtn{
    LQSiftOutVC *vc = [[LQSiftOutVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.configer = self.allVC.filterConfiger;
    @weakify(self)
    vc.confirmFilter = ^(LQFilterConfiger *configer) {
        [self_weak_.allVC setFilterConfiger:configer];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UISegmentedControl *)segmentCtrl
{
    if(_segmentCtrl) return _segmentCtrl;
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
    sgc.selectedSegmentIndex = 1;
    //监听点击
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    return sgc;
}

- (void)segmentChange:(UISegmentedControl *)sgc{
    self.index = sgc.selectedSegmentIndex;
    switch (sgc.selectedSegmentIndex) {
        case 0:{
            rightBtn.hidden = YES;
            [self replaceFromOldViewController:self.allVC toNewViewController:self.followVC];
            break;
        }
        case 1:{
            rightBtn.hidden = NO;
            [self replaceFromOldViewController:self.followVC toNewViewController:self.allVC];
            break;
        }
        default:
            break;
    }
}
/**
 *  实现控制器的切换
 *
 *  @param oldVc 当前控制器
 *  @param newVc 要切换到的控制器
 */
- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
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

