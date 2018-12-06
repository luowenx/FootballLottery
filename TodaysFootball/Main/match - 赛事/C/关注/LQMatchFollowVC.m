//
//  LQMatchFollowVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchFollowVC.h"
#import "LQMatchDetailsVC.h"
#import "LQMatchDetailsStatusViewCtrl.h"

#import "LQMatchCell.h"
#import "LQMatchShowView.h"

#import "LQMatchFollowReq.h"

#import "LQTeamInfo.h"
#import "LQMacthShowObj.h"
#import "LQMatchHeaderInfo.h"

#import "LQOptionManager.h"
#import "LQAppConfiger.h"

@interface LQMatchFollowVC ()
@property (nonatomic) BOOL needRefresh;
@end

@implementation LQMatchFollowVC{
    LQUserInfo *userInfo;
    UIView *emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self iniUI];
    userInfo = userManager.currentUser;
    if (userManager.isLogin) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self showEmptyViewInView:emptyView imageName:@"login_tips" title:@"您还没有登录，点击进行登录"];
    }
    
    @weakify(self)
    [[RACObserve(userManager, followMatchNum) skip:1] subscribeNext:^(id x) {
        self_weak_.needRefresh = YES;
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (userInfo != userManager.currentUser) {
        if (userManager.isLogin) {
            [self hiddenEmptyView];
            [self.tableView.mj_header beginRefreshing];
            self.needRefresh = NO;
        }else{
            [self.dataList removeAllObjects];
            [self.tableView reloadData];
            [self showEmptyViewInView:emptyView imageName:@"login_tips" title:@"您还没有登录，点击进行登录"];
        }
        userInfo = userManager.currentUser;
    }
    
    if(self.needRefresh){
        [self.tableView.mj_header beginRefreshing];
        self.needRefresh = NO;
    }
}

-(void)iniUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getData];
    }];
    
    emptyView = [UIView newAutoLayoutView];
    [self.view addSubview:emptyView];
    [emptyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [emptyView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [emptyView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQNavANDStatusBarHeight + kLQSafeBottomHeight];
    [emptyView autoPinEdgeToSuperviewEdge:ALEdgeTop];
}

-(void)getData
{
    NSInteger offset = 0;
    NSInteger limit = 20;
    LQMatchFollowReq *req = [[LQMatchFollowReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        [self.tableView.mj_header endRefreshing];
        LQMatchFollowRes *res = (LQMatchFollowRes *)response;
        if (res.ret == kLQNetResponseSuccess) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:[LQMacthShowObj objArrayWithDics:res.matchList]];
            [self.tableView reloadData];
        }
        if (self.dataList.count == 0) {
            emptyView.hidden = NO;
            [self showEmptyViewInView:emptyView imageName:@"empty_2" title:@"您还未关注赛事"];
        }else{
            emptyView.hidden = YES;
        }
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.dataList.count>0) {
            return;
        }
        if (error.code == kLQNetErrorCodeNotReachable) {
            emptyView.hidden = NO;
            [self showEmptyViewInView:emptyView imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
        }else{
            emptyView.hidden = YES;
        }
    }];
}

-(void)reloadEmptyView
{
    if (!userManager.isLogin) {
        [LQOptionManager loginMainInTarge:self];
        return;
    }
    [super reloadEmptyView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ====  UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LQMatchCell";
    LQMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[LQMatchCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    LQMacthShowObj *matchObj = [self.dataList safeObjectAtIndex:indexPath.row];
    cell.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:matchObj.matchTime] stringWithFormat:@"HH:mm"];
    cell.leagueLabel.text = matchObj.leagueMatch.leagueName;
    
    cell.matchShowView.homeNameLabel.text = matchObj.homeTeam.teamName;
    [cell.matchShowView.homeIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.homeTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    
    [cell.matchShowView.guestIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.guestTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    cell.matchShowView.guestNameLabel.text = matchObj.guestTeam.teamName;
    
    cell.recordLabel.text = matchObj.recordString;
    
    cell.planCountLabel.hidden = (matchObj.threadCount == 0);
    cell.arrowView.hidden = cell.planCountLabel.hidden;
    cell.planCountLabel.text = [NSString stringWithFormat:@"%@个方案", @(matchObj.threadCount)];
    switch (matchObj.matchStatus) {
        case kLQMatchStatusNotStart:{   // 未开始
            cell.statusLabel.text = @"未开始";
            cell.statusLabel.textColor = [UIColor flsMainColor2];
            cell.matchShowView.VSLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusIng:{  // 进行中
            cell.statusLabel.text = @"进行中";
            cell.statusLabel.textColor = [UIColor flsMainColor];
            cell.matchShowView.VSLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusFinished:{   // 已结束
            cell.statusLabel.text = @"已结束";
            cell.statusLabel.textColor = UIColorFromRGB(0xa2a2a2);
            cell.matchShowView.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(matchObj.homeScore),@(matchObj.guestScore)];
            break;
        }
        case kLQMatchStatusDelay:{   // 已延期
            cell.statusLabel.text = @" 已延期";
            cell.statusLabel.textColor = [UIColor flsDelayColor];
            cell.matchShowView.VSLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusCancel:{   // 已取消
            cell.statusLabel.text = @" 已取消";
            cell.statusLabel.textColor = [UIColor flsCancelColor];
            cell.matchShowView.VSLabel.text = @"VS";
            break;
        }
        default:
            break;
    }
    
    [cell cheackStatus];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LQMatchCell selfHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LQMacthShowObj *matchObj = [self.dataList safeObjectAtIndex:indexPath.row];
    LQMatchDetailsVC *vc = nil;
    
    if (LQAppConfiger.shareInstance.appStatus) {
        vc = [[LQMatchDetailsVC alloc] init];
    }else{
        vc = (LQMatchDetailsVC *)[[LQMatchDetailsStatusViewCtrl alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.matchID = matchObj.matchInfoId;
    vc.matchInfo = ({
        LQMatchHeaderInfo *matchInfo = [[LQMatchHeaderInfo alloc] init];
        matchInfo.guestScore = matchObj.guestScore;
        matchInfo.guestTeam = matchObj.guestTeam;
        matchInfo.homeScore = matchObj.homeScore;
        matchInfo.homeTeam = matchObj.homeTeam;
        matchInfo.leagueMatch = [[LQLeagueObj alloc] initWith:matchObj.leagueMatch.toJSON];
        matchInfo.matchStatus = matchObj.matchStatus;
        matchInfo.todaysfootballCategoryId = matchObj.todaysfootballCategoryId;
        matchInfo.matchStatus = matchObj.matchStatus;
        matchInfo.matchTime = matchObj.matchTime;
        matchInfo.matchInfoId = matchObj.matchInfoId;
        matchInfo.threadCount = matchObj.threadCount;
        matchInfo;
    });
    [self.navigationController pushViewController:vc animated:YES];
}


@end
