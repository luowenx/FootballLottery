//
//  LQHomevc.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHomeVC.h"
#import "LQPersonVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQMatchDetailsVC.h"
#import "LQMatchDetailsStatusViewCtrl.h"
#import "LQStaticWebViewCtrl.h"

#import "LQAppConfiger.h"

#import "MCSAutoScrollView.h"
#import "LQHomeMainTableViewCell.h"
#import "LQProgrammeDetailsVC.h"
#import "LQHomeVerbTableViewCell.h"
#import "LQBeanView.h"

#import "LQHomeDataReq.h"
#import "LQHomePlanReq.h"

#import "LQMatchHeaderInfo.h"
#import "LQExpertPlanObj.h"
#import "LQExpertDetail.h"
#import "HomeDataObj.h"
#import "LQMatchObj.h"
#import "LQLinkInfo.h"
#import "ExpertObj.h"
#import "AppUtils.h"

@interface LQHomeVC ()<UINavigationControllerDelegate, AutoScrollDelegate>

@property (nonatomic, strong) MCSAutoScrollView *carouselView;

@property (nonatomic, strong) HomeDataObj * homeDataObj;

@end

@implementation LQHomeVC{
    LQUserInfo *userInfo;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self addLeftNavWithImageName:nil hander:nil];
    self.navigationItem.title = [AppUtils bundleName];

    [self initUI];
    [self getDataisRefresh:YES];
    userInfo = userManager.currentUser;
    
    [self initObserver];
}

-(void)dealloc
{
    [self.carouselView timerfree];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
        
    if (!self.homeDataObj) {
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    
    if (userInfo != userManager.currentUser) {
        [self.tableView.mj_header beginRefreshing];
    }
    userInfo = userManager.currentUser;
    
    self.navigationController.navigationBar.hidden = YES;
    [self judgeStatusBarHidden];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)initObserver
{
    @weakify(self)
    // 购买方案通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLQPayPlanNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notifi) {
        NSDictionary *userInfo = notifi.userInfo;
        NSString *threadId = userInfo[kLQPlanIDKey];
        if (threadId.length <= 0) {
            return ;
        }
        
        for (LQExpertPlanObj *planObj in self_weak_.homeDataObj.selectExpertPlanList) {
            if ([@(planObj.threadId).stringValue isEqualToString:threadId]) {
                planObj.purchased = YES;
                [self_weak_.tableView reloadData];
                break;
            }
        }
    }];
}

-(void)initUI
{
    self.carouselView = [[MCSAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 200)];
    self.carouselView.delegate = self;
    self.tableView.tableHeaderView = self.carouselView;
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.homeDataObj.hotMatchList.count;
    }else{
        return self.homeDataObj.selectExpertPlanList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LQHomeVerbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"verbcell"];
        if (!cell) {
            cell = [[LQHomeVerbTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"verbcell"];
        }
        LQMatchObj *matchObj = [self.homeDataObj.hotMatchList safeObjectAtIndex:indexPath.row];
        cell.leagueLabel.text = [NSString stringWithFormat:@"【%@】", matchObj.leagueName];
        [cell.leftTeamImageView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.homeIcon] placeholderImage:LQPlaceholderTeamIcon];
        cell.leftTeamLabel.text = matchObj.homeName;
        cell.rightTeamLabel.text = matchObj.guestName;
        [cell.rightTeamImageView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.guestIcon] placeholderImage:LQPlaceholderTeamIcon];
        cell.leagueTimeLabel.text = [NSString stringFormatIntervalSince1970_HourMinute_colon:matchObj.matchDate];
        cell.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:matchObj.matchTime];

        return cell;
    }else{
        LQHomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homecell"];
        if (!cell) {
            cell = [[LQHomeMainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"homecell"];
        }
        @weakify(self)
        cell.persobAction = ^(LQExpertPlanObj* dataObj) { // 专家详情
            LQPersonVC *vc = [[LQPersonVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.userID = @(dataObj.expert.userId);
            vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.expert.toJSON];
            [self_weak_.navigationController pushViewController:vc animated:YES];
        };
        
        cell.programmeAction = ^(LQExpertPlanObj* dataObj) { // 方案详情
            LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.proID = @(dataObj.threadId);
            [self_weak_.navigationController pushViewController:vc animated:YES];
        };
        
        cell.matchAction = ^(LQExpertPlanObj* dataObj) { // 比赛详情
            LQMatchDetailsVC *vc = nil;
            
            if (LQAppConfiger.shareInstance.appStatus) {
                vc = [[LQMatchDetailsVC alloc] init];
            }else{
                vc = (LQMatchDetailsVC *)[[LQMatchDetailsStatusViewCtrl alloc] init];
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            vc.matchInfo = [self_weak_ matchHeaderInfoWithEarliestMatch:dataObj.earliestMatch];
            vc.matchID = dataObj.earliestMatch.matchInfoId;
            [self_weak_.navigationController pushViewController:vc animated:YES];
        };
        
        LQExpertPlanObj *planObj = [self.homeDataObj.selectExpertPlanList safeObjectAtIndex:indexPath.row];
        [cell.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:planObj.expert.avatar] placeholderImage:LQPlaceholderIcon];
        cell.expertNameLabel.text = planObj.expert.nickname;
        cell.expertDescriptionLabel.text = planObj.expert.slogan;
        cell.straightLabel.text = [NSString stringWithFormat:@"%@连红", @(planObj.expert.maxWin)];
        cell.straightLabel.hidden = planObj.expert.maxWin == 0;

        cell.hitRateLabel.hidden = !planObj.expert.showHitRate;
        cell.signView.hidden = !planObj.expert.showHitRate;
        cell.hitDesLabel.hidden = !planObj.expert.showHitRate;
        cell.hitRateLabel.text = @((int)(round(planObj.expert.hitRate * 100))).stringValue;
        cell.hitDesLabel.text = @"命中率";
        cell.titleLabel.text = planObj.threadTitle;
        cell.matchLabel.text = planObj.earliestMatch.leagueName;
        cell.ranksLeftLabel.text = planObj.earliestMatch.homeName;
        cell.ranksRightLabel.text = planObj.earliestMatch.guestName;
        cell.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:planObj.earliestMatch.matchTime];
        cell.timeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:planObj.publishTime];
        cell.lookNumbersLabel.text = [NSString stringWithFormat:@"已查看%@次", @(planObj.views)];

        if ((planObj.plock < kLQThreadPlockFinished) && (!planObj.purchased)&&(planObj.price)) { // 未购买并且价格不为0
            cell.beanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(planObj.price)];
            cell.beanView.hidden = NO;
            cell.lookButton.hidden = YES;
        }else{// 显示查看
            cell.beanView.hidden = YES;
            cell.lookButton.hidden = NO;
        }
        
        cell.dataObj = planObj;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {// 比赛详情
        LQMatchObj *matchObj = [self.homeDataObj.hotMatchList safeObjectAtIndex:indexPath.row];
        LQMatchDetailsVC *matchDetailVC = [[LQMatchDetailsVC alloc] init];
        matchDetailVC.matchID = matchObj.matchInfoId;
        matchDetailVC.matchInfo = [self matchHeaderInfoWithEarliestMatch:matchObj];
        matchDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:matchDetailVC animated:YES];
    }else{
        LQExpertPlanObj *planObj = [self.homeDataObj.selectExpertPlanList safeObjectAtIndex:indexPath.row];
        //方案详情
        LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.proID = @(planObj.threadId);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [UIFont systemFontOfSize:10].lineHeight + [UIFont systemFontOfSize:12].lineHeight + 11 + 15;
    }
    LQExpertPlanObj *planObj = [self.homeDataObj.selectExpertPlanList safeObjectAtIndex:indexPath.row];
    if (planObj.cacheHeight <= CGFLOAT_MIN) {
        CGFloat cellHeight = [LQHomeMainTableViewCell staticHeight];
        cellHeight += [planObj.threadTitle sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
        planObj.cacheHeight = cellHeight;
    }
    return planObj.cacheHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.homeDataObj.hotMatchList.count>0 ? 50 : 0.001;
    }
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.homeDataObj.hotMatchList.count == 0) {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *hotIcon = [UIImageView newAutoLayoutView];
        hotIcon.image = imageWithName(@"热门赛事");
        [headerView addSubview:hotIcon];
        [hotIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [hotIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [hotIcon autoSetDimensionsToSize:CGSizeMake(26, 23)];
        
        UILabel *hotLable = [UILabel newAutoLayoutView];
        hotLable.text = @"热门赛事";
        hotLable.font = [UIFont systemFontOfSize:14];
        hotLable.textColor = UIColorFromRGB(0xff3030);
        [headerView addSubview:hotLable];
        [hotLable autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [hotLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:hotIcon withOffset:10];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        [headerView addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:1];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 54)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *hotIcon = [UIImageView newAutoLayoutView];
        hotIcon.image = imageWithName(@"精选");
        [headerView addSubview:hotIcon];
        [hotIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [hotIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [hotIcon autoSetDimensionsToSize:CGSizeMake(26, 26)];
        
        UILabel *hotLable = [UILabel newAutoLayoutView];
        hotLable.text = @"精选方案";
        hotLable.font = [UIFont systemFontOfSize:14];
        hotLable.textColor = UIColorFromRGB(0xff3030);
        [headerView addSubview:hotLable];
        [hotLable autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [hotLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:hotIcon withOffset:10];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor flsSpaceLineColor];
        [headerView addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingSpecial];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingSpecial];
        [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];

        UIView *lineTop = [UIView newAutoLayoutView];
        lineTop.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [headerView addSubview:lineTop];
        [lineTop autoSetDimension:ALDimensionHeight toSize:4];
        [lineTop autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        return headerView;
    }
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = [self tableView:self.tableView heightForHeaderInSection:1];
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    [self judgeStatusBarHidden];
}

#pragma mark ==== AutoScrollDelegate
- (void)autoScrollLoadImageCell:(MCSImageCell *)cell cellData:(LQLinkInfo *)data
{
    [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:data.imgUrl]];
}

- (void)autoScrollDidSelectItemWithData:(LQLinkInfo *)itemInfo
{
    if (itemInfo.redirectUrl.length<=0) {
        return;
    }
    LQStaticWebViewCtrl *webViewCtrl = [[LQStaticWebViewCtrl alloc] init];
    webViewCtrl.requestURL = itemInfo.redirectUrl;
    webViewCtrl.showWebTitle = YES;
    [self.navigationController pushViewController:webViewCtrl animated:YES];
}

#pragma mark == tool
// 赛事详情头部
-(LQMatchHeaderInfo *)matchHeaderInfoWithEarliestMatch:(LQMatchObj *)earliestMatch
{
    return ({
        LQMatchHeaderInfo *matchInfo = [[LQMatchHeaderInfo alloc] init];
        matchInfo.guestScore = earliestMatch.guestScore;
        matchInfo.homeScore = earliestMatch.homeScore;
        matchInfo.matchInfoId = earliestMatch.matchInfoId;
        matchInfo.matchStatus = earliestMatch.matchStatus;
        matchInfo.matchTime = earliestMatch.matchTime;
        
        matchInfo.homeTeam = ({
            LQTeamInfo *homeTeam = [[LQTeamInfo alloc] init];
            homeTeam.teamName = earliestMatch.homeName;
            homeTeam.teamIcon = earliestMatch.homeIcon;
            homeTeam;
        });
        
        matchInfo.guestTeam = ({
            LQTeamInfo *guestTeam = [[LQTeamInfo alloc] init];
            guestTeam.teamIcon = earliestMatch.guestIcon;
            guestTeam.teamName = earliestMatch.guestName;
            guestTeam;
        });
        
        matchInfo.leagueMatch = ({
            LQLeagueObj *leagueMatch = [[LQLeagueObj alloc] init];
            leagueMatch.leagueName = earliestMatch.leagueName;
            leagueMatch.leagueId = earliestMatch.leagueId;
            leagueMatch;
        });
        
        matchInfo;
    });
}

-(void)judgeStatusBarHidden
{
    CGFloat offset = self.tableView.contentOffset.y + kLQStatusBarHeight * .5;

    if (offset >= 200) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

#pragma mark === 数据请求

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    [self getDataisRefresh:YES];
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        LQHomeDataReq *dataReq = [[LQHomeDataReq alloc] init];
        [dataReq requestWithCompletion:^(id response) {
            [self.tableView.mj_header endRefreshing];
            LQNetResponse *res = (LQNetResponse*)response;
            if (res.ret == 0) {
                self.homeDataObj = [[HomeDataObj alloc] initWith:res.data];
                
                [self.carouselView reloadScrollData:self.homeDataObj.headList];
                self.tableView.hidden = NO;
                self.tableView.mj_footer.hidden = NO;

                [self.tableView reloadData];
            }else{
                self.tableView.mj_footer.hidden = YES;
            }

        } error:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showError:error];
            if(self.dataList.count<=0 && error.code == kLQNetErrorCodeNotReachable){
                self.tableView.hidden = YES;
                self.tableView.mj_footer.hidden = YES;
            }
        }];
        return;
    }
    
    NSInteger offset = self.homeDataObj.selectExpertPlanList.count;
    NSInteger limit = 10;
    LQHomePlanReq *planReq = [[LQHomePlanReq alloc] init];
    [planReq apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [planReq requestWithCompletion:^(id response) {
        [self.tableView.mj_footer endRefreshing];
        LQNetResponse *res = (LQNetResponse*)response;
        if (res.ret == 0) {
            NSMutableArray *tmpArray = (self.homeDataObj.selectExpertPlanList?:@[]).mutableCopy;
            [tmpArray addObjectsFromArray:[LQExpertPlanObj objArrayWithDics:(NSArray<NSDictionary*>*)res.data]];
            self.homeDataObj.selectExpertPlanList = tmpArray.copy;
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    if (!isShowHomePage) {
        return;
    }

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


@end
