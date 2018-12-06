//
//  LQMatchAllThree.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchAllThree.h"
#import "LQMatchDetailsVC.h"
#import "LQMatchDetailsStatusViewCtrl.h"

#import "LQMatchCell.h"
#import "LQMatchShowView.h"

#import "LQMatchScheduleReq.h"

#import "LQTeamInfo.h"
#import "LQMacthShowObj.h"
#import "LQMatchHeaderInfo.h"
#import "LQAppConfiger.h"

@interface LQMatchAllThree ()
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, copy) NSString *filterLeagueIds;

@end

@implementation LQMatchAllThree
{
    BOOL isLogin;
}
@synthesize filterData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self getDataisRefresh:YES];
    isLogin = userManager.isLogin;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLogin != userManager.isLogin) {
        [self.tableView.mj_header beginRefreshing];
    }
    isLogin = userManager.isLogin;
}

- (void)initUI
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"无更多内容" forState:(MJRefreshStateNoMoreData)];
}

-(void)filterWithLeague:(NSString *)leagueIds
{
    _filterLeagueIds = leagueIds;
    [self.tableView.mj_header beginRefreshing];
}

- (void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0 : self.totalDataCount;
    NSInteger limit = 20;
    LQMatchScheduleReq *req = [[LQMatchScheduleReq alloc] init];
    
    BOOL filter = self.filterLeagueIds.length>0;
    if(filter){
        [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@/%@", @(offset), @(limit), self.filterLeagueIds]];
    }else{
        [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    }
    [req requestWithCompletion:^(id response) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableView.mj_footer.hidden = NO;

        if (isRefresh) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.titleArray removeAllObjects];
            [self.dataList removeAllObjects];
        }
        
        LQMatchScheduleRes *res = (LQMatchScheduleRes *)response;
        [self handleDicArray:res.matchList];
        [self.tableView reloadData];
        
        if (res.matchCount <= self.totalDataCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if(self.filterData){
            self.filterData(filter, res.matchCount);
        }
    } error:^(NSError *error) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self showError:error];
        if (error.code == kLQNetErrorCodeNotReachable) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.tableView.mj_footer.hidden = YES;
    }];
}

- (void)handleDicArray:(NSArray *)dicArray
{
    NSMutableArray *dataList = self.dataList?self.dataList.mutableCopy:@[].mutableCopy;
    NSMutableArray *titleList = self.titleArray?self.titleArray.mutableCopy:@[].mutableCopy;
    
    for (NSDictionary *dic in dicArray) {
        LQMacthShowObj *matchObj = [[LQMacthShowObj alloc] initWith:dic];
        if (matchObj.matchDate.length<=0) {
            continue;
        }
        
        if (![titleList containsObject:matchObj.matchDate]) {
            [titleList addObject:matchObj.matchDate];
            [dataList addObject:@[matchObj].mutableCopy];
        }else{
            NSInteger index = [titleList indexOfObject:matchObj.matchDate];
            NSMutableArray *subArray = [dataList safeObjectAtIndex:index];
            [subArray addObject:matchObj];
        }
    }
    
    self.titleArray = titleList.mutableCopy;
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:dataList.copy];
}

- (NSInteger)totalDataCount
{
    NSInteger totalCount = 0;
    
    for (NSInteger section = 0; section < self.tableView.numberOfSections; section++) {
        totalCount += [self.tableView numberOfRowsInSection:section];
    }
    return totalCount;
}

#pragma mark === UITableViewDelegate,UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *subArray = [self.dataList safeObjectAtIndex:section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQMatchCell"];
    if (!cell) {
        cell = [[LQMatchCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQMatchCell"];
    }
    NSArray *subArray = [self.dataList safeObjectAtIndex:indexPath.section];
    LQMacthShowObj *matchObj = [subArray safeObjectAtIndex:indexPath.row];
    cell.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:matchObj.matchTime] stringWithFormat:@"HH:mm"];
    cell.leagueLabel.text = matchObj.leagueMatch.leagueName;
    
    cell.matchShowView.homeNameLabel.text = matchObj.homeTeam.teamName;
    [cell.matchShowView.homeIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.homeTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    
    [cell.matchShowView.guestIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchObj.guestTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    cell.matchShowView.guestNameLabel.text = matchObj.guestTeam.teamName;
    
    cell.recordLabel.text = [matchObj.recordString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
    NSArray *subArray = [self.dataList safeObjectAtIndex:indexPath.section];
    LQMacthShowObj *matchObj = [subArray safeObjectAtIndex:indexPath.row];

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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 16)];
    sectionHeader.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UILabel *label = [UILabel newAutoLayoutView];
    label.text = [self.titleArray safeObjectAtIndex:section];
    label.font = [UIFont lqsFontOfSize:22];
    label.textColor = UIColorFromRGB(0x7a7a7a);
    [sectionHeader addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    return sectionHeader;
}

@end


