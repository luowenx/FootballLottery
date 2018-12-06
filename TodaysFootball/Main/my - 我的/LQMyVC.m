//
//  LQMyvc.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyVC.h"
#import "LQMyTableViewCell.h"
#import "LQMyOtherTableViewCell.h"
#import "LQNeedLoginHeaderView.h"

#import "LQCollectionVC.h"
#import "LQOrderVC.h"
#import "LQCouponVC.h"
#import "LQFeedbackVC.h"
#import "LQRechargeVC.h"
#import "LQSetupVC.h"
#import "LQBalanceVC.h"
#import "LQStaticWebViewCtrl.h"
#import "LQLoginMainViewCtrl.h"
#import "LQFollowVC.h"
#import "LQMeCommentsViewCtrl.h"
#import "LQMeInformationViewCtrl.h"

#import "LQLoginManager.h"
#import "LQAppConfiger.h"

typedef NS_ENUM(NSInteger, LQMineTag) {
    kLQMineTagCollection,    // 收藏
    kLQMineTagExpert,         // 专家
    kLQMineTagOrder,           //  订单
    kLQMineTagCoupons,     //  优惠券
    kLQMineTagFeedback,    //  意见反馈
    kLQMineTagHelpCenter,  //  帮助中心
    
    kLQMineTagMeInformation,  // 我的资讯
    kLQMineTagMeComments,  // 我的评论
};


const NSString *kMineTagKey = @"kMineTagKey";
const NSString *kMineIconKey = @"kMineIconKey";
const NSString *kMineTitleKey = @"kMineTitleKey";
const NSString *kMineSelectorKey = @"kMineSelectorKey";

@interface LQMyVC ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *sectonArray;
@end

@implementation LQMyVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
    
    @weakify(self)
    [[RACObserve([LQAppConfiger shareInstance], appStatus) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self initData];
        [self.mainTableView reloadData];
    }];
}

- (void)initData
{
    NSMutableArray *section0 = @[@{}].mutableCopy;
    NSMutableArray *section1 = @[].mutableCopy;
    NSMutableArray *section2 = @[].mutableCopy;
    NSMutableArray *section3 = @[].mutableCopy;
    NSMutableArray *sectionStatus = @[].mutableCopy;
    
    if ([LQAppConfiger shareInstance].appStatus) {
        
        [section1 addObject:@{
                              kMineTagKey : @(kLQMineTagCollection),
                              kMineIconKey: @"我的收藏",
                              kMineTitleKey:@"我的收藏",
                              kMineSelectorKey:NSStringFromSelector(@selector(gotoMyCollection)),}];
        
        [section1 addObject:@{
                              kMineTagKey : @(kLQMineTagExpert),
                              kMineIconKey: @"专家",
                              kMineTitleKey:@"关注专家",
                              kMineSelectorKey:NSStringFromSelector(@selector(gotoExpert)),}];
        
        
        [section2 addObject:@{
                              kMineTagKey : @(kLQMineTagOrder),
                              kMineIconKey: @"订单",
                              kMineTitleKey:@"我的订单",
                              kMineSelectorKey:NSStringFromSelector(@selector(gotoMyOrder)),}];
        
        [section2 addObject:@{
                              kMineTagKey : @(kLQMineTagCoupons),
                              kMineIconKey: @"我的_优惠券",
                              kMineTitleKey:@"优惠券",
                              kMineSelectorKey:NSStringFromSelector(@selector(gotoCoupons)),}];
        
        [section3 addObject:@{
                              kMineTagKey : @(kLQMineTagHelpCenter),
                              kMineIconKey: @"帮助",
                              kMineTitleKey:@"帮助中心",
                              kMineSelectorKey:NSStringFromSelector(@selector(gotoHelpCenter)),}];
      
    }
    
    [sectionStatus addObject:@{
                               kMineTagKey : @(kLQMineTagMeInformation),
                               kMineIconKey: @"me_infomation",
                               kMineTitleKey:@"我的资讯",
                               kMineSelectorKey:NSStringFromSelector(@selector(gotoMyInformation)),}];
    
    [sectionStatus addObject:@{
                               kMineTagKey : @(kLQMineTagMeComments),
                               kMineIconKey: @"me_bb",
                               kMineTitleKey:@"我的评论",
                               kMineSelectorKey:NSStringFromSelector(@selector(gotoMyComments)),}];
    
    
    [section3 addObject:@{
                          kMineTagKey : @(kLQMineTagFeedback),
                          kMineIconKey: @"意见反馈",
                          kMineTitleKey:@"意见反馈",
                          kMineSelectorKey:NSStringFromSelector(@selector(gotoFeedback)),}];
    

    if ([LQAppConfiger shareInstance].appStatus) {
        _sectonArray = @[section0, section1, section2, sectionStatus,section3].mutableCopy;
    }else{
        _sectonArray = @[section0, sectionStatus, section3].mutableCopy;
    }
    
}

- (void)creatUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.mainTableView.scrollEnabled = [UIDevice isDevicePad];
    self.mainTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.mainTableView];
    [self.mainTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mainTableView.contentInset = UIEdgeInsetsZero;
    }
    
    @weakify(self)
    [RACObserve(userManager, currentUser) subscribeNext:^(id x) {
        [self_weak_.mainTableView reloadData];
    }];
    
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectonArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.sectonArray safeObjectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        // 其他的cell
        LQMyOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"othercell"];
        if (!cell) {
            cell = [[LQMyOtherTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"othercell"];
        }
        NSDictionary *dic = [[self.sectonArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
        cell.iconView.image = imageWithName(dic[kMineIconKey]);
        cell.titleLabel.text = dic[kMineTitleKey];
        cell.topLine.hidden = !(indexPath.row == 1);
        return  cell;
    }
    if (!userManager.isLogin) { // 未登录
        LQNeedLoginHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:@"LQNeedLoginHeaderViewid"];
        if (!cell) {
            cell = [[LQNeedLoginHeaderView alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQNeedLoginHeaderViewid"];
        }
        @weakify(self)
        cell.login = ^(LQLoginWayType useType) {
            [self_weak_ gotoLoginUseType:useType];
        };
        
        cell.setting = ^{
            LQSetupVC *vc = [[LQSetupVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self_weak_.navigationController pushViewController:vc animated:YES];
        };
        
        cell.recharge = ^{
            if (!userManager.isLogin) {
                [self_weak_ gotoLogin];
                return;
            }
            LQRechargeVC *vc = [[LQRechargeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self_weak_.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    // 登录之后
    LQMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topcell"];
    if (!cell) {
        cell = [[LQMyTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"topcell"];
    }

    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userManager.currentUser.avatar] placeholderImage:LQPlaceholderIcon options:(SDWebImageRefreshCached)];// 该图片不使用缓存，QQ头像的URL地址可能会不变
    cell.nameLabel.text = userManager.currentUser.nickName;
    cell.beanLabel.text = @(userManager.currentUser.colorbean).stringValue;
    
    @weakify(self)
    cell.setting = ^{
        LQSetupVC *vc = [[LQSetupVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    cell.recharge = ^{
        LQRechargeVC *vc = [[LQRechargeVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    cell.balance = ^{
        LQBalanceVC *balanceVC = [[LQBalanceVC alloc] init];
        balanceVC.hidesBottomBarWhenPushed = YES;
        [self_weak_.navigationController pushViewController:balanceVC animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    NSDictionary *dic = [[self.sectonArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];

    SEL selector = NSSelectorFromString(dic[kMineSelectorKey]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
#pragma clang diagnostic pop
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 156;
    }else{
        return 51;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section <= 1) {
        return 0.1;
    }else{
        return 16;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    if(offset_Y <= 0){
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}


#pragma mark  === lazy selector
-(void)gotoMyCollection
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQCollectionVC *vc = [[LQCollectionVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoExpert
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQFollowVC *vc = [[LQFollowVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoMyOrder
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQOrderVC *vc = [[LQOrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoCoupons
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQCouponVC *vc = [[LQCouponVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoFeedback
{
    LQFeedbackVC *vc = [[LQFeedbackVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoHelpCenter
{
    
    LQStaticWebViewCtrl *webViewCtrl = [[LQStaticWebViewCtrl alloc] init];
    webViewCtrl.title = @"帮助中心";
    webViewCtrl.requestURL = [NSString stringWithFormat:@"%@/userCenter/help%@", LQWebURL, LQWebPramSuffix];
    webViewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewCtrl animated:YES];
}

-(void) gotoLoginUseType:(LQLoginWayType)type
{
    if (type == kLQLoginWayTypePhone) {
        [self gotoLogin];
    }else  {
        [self.view showActivityViewWithTitle:@"登录中"];
        [LQLoginManager.loginManager loginWithType:type
                       aParameters:nil
                          callBack:^(BOOL success, NSError *error) {
                              if (success) {
                                  [self.view hiddenActivityWithTitle:@"登陆成功"];
                              }else{
                                  if (error && error.code == kLQLoginErrorCodeInstallEnterEnterForeground) {
                                      [self.view hiddenActivityWithTitle:nil];
                                  }else{
                                      [self.view hiddenActivityWithTitle:@"登录失败"];
                                  }
                              }
                          }];
    }
}

-(void)gotoLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LQLoginMainViewCtrl *logViewCtrl = [[LQLoginMainViewCtrl alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewCtrl];
        [self presentViewController:nav animated:YES completion:^{}];
    });
}

 // 我的资讯
-(void)gotoMyInformation
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQMeInformationViewCtrl *vc = [[LQMeInformationViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

 // 我的评论
-(void)gotoMyComments
{
    if (!userManager.isLogin) {
        [self gotoLogin]; return;
    }
    LQMeCommentsViewCtrl *vc = [[LQMeCommentsViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

@end
