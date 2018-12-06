//
//  LQFollowVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFollowVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQPersonVC.h"

#import "LQFollowTableViewCell.h"
#import "LQRecommendView.h"

#import "LQExpertFollowReq.h"

#import "ExpertObj.h"
#import "LQMatchObj.h"
#import "LQExpertPlanObj.h"
#import "LQOptionManager.h"
#import "LQExpertDetail.h"

CGFloat kFollowExpertHeight__ = 250;

@interface LQFollowVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) LQRecommendView * footerView;

@property (nonatomic, strong) NSMutableArray * followList;
//@property (nonatomic, strong) NSMutableArray * recommendList;

@property (nonatomic, copy) NSString * emptyTitle;
@property (nonatomic, copy) NSString * emptyImageName;

@property (nonatomic) BOOL needRefesh;

@end

@implementation LQFollowVC{
    LQUserInfo *userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self getData];
    userInfo = userManager.currentUser;
    if (!userManager.isLogin) {
        self.emptyTitle = @"您还没有登录，点击进行登录";
        self.emptyImageName = @"login_tips";
    }
    
    @weakify(self)
    [[RACObserve(userManager, followExpertNum) skip:1] subscribeNext:^(id x) {
        self_weak_.needRefesh = YES;
    }];
    
    // 购买方案通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLQPayPlanNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notifi) {
        NSDictionary *userInfo = notifi.userInfo;
        NSString *threadId = userInfo[kLQPlanIDKey];
        if (threadId.length <= 0) {
            return ;
        }
        
        for (LQExpertPlanObj *planObj in self_weak_.followList) {
            if ([@(planObj.threadId).stringValue isEqualToString:threadId]) {
                planObj.purchased = YES;
                [self_weak_.tableView reloadData];
                break;
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (userInfo != userManager.currentUser) {
        if (userManager.isLogin) {
            [self hiddenEmptyView];
            [self.tableView.mj_header beginRefreshing];
            self.needRefesh = NO;
        }else{
            [self.followList removeAllObjects];
            [self.tableView reloadData];
            self.emptyTitle = @"您还没有登录，点击进行登录";
            self.emptyImageName = @"login_tips";
        }
    }
    userInfo = userManager.currentUser;
    
    if(self.needRefesh){
        [self.tableView.mj_header beginRefreshing];
        self.needRefesh = NO;
    }
    self.navigationController.navigationBar.hidden = NO;
}

-(void)initUI
{
    self.title = @"关注专家";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
//    _footerView = [[LQRecommendView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kFollowExpertHeight__)];
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kFollowExpertHeight__)];
//    [footerView addSubview:_footerView];
//    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    @weakify(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getData];
    }];
    
//    _footerView.title = ^NSString *(LQBaseExpertInfo *dataObj) {
//        return dataObj.nickname;
//    };
//
//    _footerView.setImage = ^(LQBaseExpertInfo *dataObj, LQAvatarView *__weak imageView) {
//        [imageView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dataObj.avatar]];
//    };
//
//    _footerView.selected = ^(LQBaseExpertInfo *dataObj) {
//        LQPersonVC *vc = [[LQPersonVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.userID = @(dataObj.userId);
//        vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.toJSON];
//        [self_weak_.navigationController pushViewController:vc animated:YES];
//    };
}

- (void)getData
{
    NSInteger offset = 0;
    NSInteger limit = 20;
    LQExpertFollowReq *req = [[LQExpertFollowReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        [self.tableView.mj_header endRefreshing];
        LQExpertFollowRes *res = (LQExpertFollowRes *)response;
        if (res.ret == kLQNetResponseSuccess) {
//            self.recommendList = [LQBaseExpertInfo objArrayWithDics:res.recommendExpertList].mutableCopy;
//            self.footerView.dataArray = self.recommendList;
            if (userManager.isLogin) {
                self.followList = [LQExpertPlanObj objArrayWithDics:res.followExpertPlanList].mutableCopy;
                self.emptyTitle = @"还未关注任何专家";
                self.emptyImageName = @"empty_1";
            }
        }
//        if (self.recommendList.count<=0) {
//            self.footerView.hidden = YES;
//        }else{
//            self.footerView.hidden = NO;
//            [self.footerView.collectionView reloadData];
//        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error.code == kLQNetErrorCodeNotReachable) {
//            self.footerView.hidden = YES;
            self.emptyImageName = @"notNetReachable";
            self.emptyTitle = @"点击屏幕重新加载";
            [self.tableView reloadData];
        }
    }];
}

-(void)reloadEmptyView
{
    if (!userManager.isLogin) {
        [LQOptionManager loginMainInTarge:self];
        return;
    }
    if (![self.emptyImageName isEqualToString:@"notNetReachable"]) {
        return;
    }
    [super reloadEmptyView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ===  UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(self.followList.count, 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.followList.count<=0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.emptyImageName.length > 0) {
            [self showEmptyViewInView:cell.contentView imageName:self.emptyImageName title:self.emptyTitle];
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        return cell;
    }
    
    static NSString *cellid = @"LQFollowTableViewCellid";
    LQFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LQFollowTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellid];
    }
    LQExpertPlanObj *planObj = [self.followList safeObjectAtIndex:indexPath.row];
    [cell.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:planObj.expert.avatar] placeholderImage:LQPlaceholderIcon];
    cell.expertNameLabel.text = planObj.expert.nickname;
    cell.expertDescriptionLabel.text = planObj.expert.slogan;
    cell.titleLabel.text = planObj.title;
    cell.matchLabel.text = planObj.earliestMatch.leagueName;
    cell.ranksLeftLabel.text = planObj.earliestMatch.homeName;
    cell.ranksRightLabel.text = planObj.earliestMatch.guestName;
    cell.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:planObj.earliestMatch.matchTime];
    cell.timeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:planObj.publishTime];
    cell.matchView.backgroundColor = [UIColor clearColor];
    
    if (planObj.plock == kLQThreadPlockFinished) {
        cell.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(planObj.earliestMatch.homeScore), @(planObj.earliestMatch.guestScore)];
    }else{
        cell.VSLabel.text = @"VS";
    }
    cell.lookNumbersLabel.text = [NSString stringWithFormat:@"已查看%@次", @(planObj.views)];

    if ((planObj.plock != 3) && (!planObj.purchased)&&(planObj.price)) { // 未购买并且价格不为0
        cell.beanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(planObj.price)];
        cell.beanView.hidden = NO;
        cell.lookButton.hidden = YES;
//        cell.lookNumbersLabel.hidden = NO;
    }else{// 显示查看
        cell.beanView.hidden = YES;
        cell.lookButton.hidden = NO;
//        cell.lookNumbersLabel.hidden = YES;
    }
    
    cell.dataObj = planObj;
    
    @weakify(self)
    cell.persobAction = ^(LQExpertPlanObj* dataObj) { // 专家详情
        LQPersonVC *vc = [[LQPersonVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userID = @(dataObj.expert.userId);
        vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.expert.toJSON];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    cell.matchAction = ^(LQExpertPlanObj* dataObj) {
        LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.proID = @(dataObj.threadId);
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.followList.count<=0) {
        return CGRectGetHeight(self.view.frame);
//        if ([UIDevice isDevicePad]) {return 250; }
//        return CGRectGetHeight(self.view.frame) - kFollowExpertHeight__;
    }
    LQExpertPlanObj *planObj = [self.followList safeObjectAtIndex:indexPath.row];
    if (planObj.cacheHeight <= CGFLOAT_MIN) {
        CGFloat cellHeight = [LQFollowTableViewCell staticHeight];
        cellHeight += [planObj.title sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
        planObj.cacheHeight = cellHeight;
    }
    return planObj.cacheHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.followList.count<=0) {
        return;
    }
    LQExpertPlanObj *planObj = [self.followList safeObjectAtIndex:indexPath.row];
    LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.proID = @(planObj.threadId);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
