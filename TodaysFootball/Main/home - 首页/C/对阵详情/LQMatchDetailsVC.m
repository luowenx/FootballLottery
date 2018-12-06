//
//  LQMatchDetailsVC.m
//  SGPageViewExample
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "LQMatchDetailsVC.h"
#import "LQPersonVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQLoginMainViewCtrl.h"
#import "LQWebViewCtrl.h"

#import "MCSPageingView.h"
#import "MatchDetailsTopV.h"
#import "LQMatTableViewCell.h"
#import "LQSwichCtrl.h"
#import "LQMatchWebView.h"
#import "LQTitleView.h"

#import "LQMatchInfoReq.h"
#import "LQMatchListReq.h"
#import "LQOptionManager.h"

#import "LQMatchListInfo.h"
#import "LQExpertDetail.h"
#import "ExpertObj.h"
#import "LQMatchWebViewModel.h"
#import "LQMatchHeaderInfo.h"

const CGFloat HeaderViewHeight__ = 225;
@interface LQMatchDetailsVC () <UITableViewDelegate, UITableViewDataSource>
/*****************  视图  *********************/
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) LQTitleView * titleView;
// 表头
@property (nonatomic, strong) MatchDetailsTopV * matchTopView;
// 分栏
@property (nonatomic, strong) MCSPageingView * pageView;
// 分析
@property (nonatomic, strong) LQMatchWebView * analysisView;
//  指数
@property (nonatomic, strong) LQMatchWebView * indexView;
// 直播
@property (nonatomic, strong) LQMatchWebView * liveView;
// 无数据空白样式
@property (nonatomic, strong) UIView * emptyView;

/*****************  数据  *********************/
@property (nonatomic, strong) NSMutableArray *matchList;

/*****************  逻辑  *********************/
@property (nonatomic, strong) LQMatchWebViewModel * webViewModel;

@end

@implementation LQMatchDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.matchList = [NSMutableArray arrayWithCapacity:0];
    [self initUI];
    [self initViewModel];
    // 先加载一次传过来的数据
    [self reloadHeaderView];
    [self getHeaderData];
    [self getMatchListDataIsRefresh:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initUI
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, HeaderViewHeight__)];
    [header addSubview:self.matchTopView];
    
    self.tableView.tableHeaderView = header;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _titleView = [LQTitleView newAutoLayoutView];
    _titleView.backgroundView.image = imageWithName(@"match_top_bg");
    _titleView.titleLabel.font = [UIFont lqsFontOfSize:32];
    _titleView.alpha = 0;
    _titleView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 32); // size(12, 20)
    [self.view addSubview:_titleView];
    [_titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"webcelllive"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"webcellindex"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"webcellanalysis"];
    
    @weakify(self)
    [[self.matchTopView.backBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_.navigationController popViewControllerAnimated:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getMatchListDataIsRefresh:NO];
    }];
    
    // 查看比赛队伍详细信息，这两个事件暂时不需要了
//    self.matchTopView.lookHomeTeam = ^{
//        NSString *webUrl = self_weak_.matchInfo.webView[@"homeTeamUrl"];
//        if (webUrl.length <= 0) {
//            return ;
//        }
//        LQWebViewCtrl *webVC = [[LQWebViewCtrl alloc] init];
//        webVC.requestURL = webUrl;
//        webVC.title = @"Team";
//        [self_weak_.navigationController pushViewController:webVC animated:YES];
//    };
//
//    self.matchTopView.lookguestTeam = ^{
//        NSString *webUrl = self_weak_.matchInfo.webView[@"guestTeamUrl"];
//        if (webUrl.length <= 0) {
//            return ;
//        }
//        LQWebViewCtrl *webVC = [[LQWebViewCtrl alloc] init];
//        webVC.requestURL = webUrl;
//        webVC.title = @"Team";
//        [self_weak_.navigationController pushViewController:webVC animated:YES];
//    };
    
    // 关注比赛
    [[self.matchTopView.followBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *followBtn) {
        
        if (!userManager.isLogin) {
            [LQOptionManager loginMainInTarge:self_weak_];return;
        }
        
        [self_weak_.view showActivityViewWithTitle:nil];
        [LQOptionManager followMatchCurrentisFollowed:followBtn.isSelected
                                          matchInfoId:@(self_weak_.matchInfo.matchInfoId).stringValue
                                             callBack:^(BOOL success, NSError *error) {
                                                 if (success) {
                                                     [self_weak_.view hiddenActivityWithTitle:@"操作成功"];
                                                     followBtn.selected = !followBtn.isSelected;
                                                     self_weak_.matchInfo.hasFollowed = followBtn.selected;
                                                 }else{
                                                     [self_weak_.view hiddenActivityWithTitle:@"操作失败"];
                                                 }
                                             }];
    }];
    
    [self.titleView updateLeftImageName:@"return" handler:^(UIButton *sender) {
        [self_weak_ onBack];
    }];
}

- (void)initViewModel
{
    self.webViewModel = [[LQMatchWebViewModel alloc] init];
    [self.webViewModel setMatchId:@(self.matchID).stringValue];
    
    @weakify(self)
    [[RACObserve(userManager, currentUser) skip:1] subscribeNext:^(id x) {
        [self_weak_ getHeaderData];
        [self_weak_ getMatchListDataIsRefresh:YES];
    }];
}

- (void)reloadHeaderView
{
    // 后期需要全部转成对象、并且不要直接用 LQNetResponse的子类传值赋值
    self.matchTopView.titleL.text = self.matchInfo.leagueMatch.leagueName;
    [self.matchTopView.leftIma sd_setImageWithURL:[NSURL URLWithString:self.matchInfo.homeTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    self.matchTopView.leftNameL.text = self.matchInfo.homeTeam.teamName;
    [self.matchTopView.rightIma sd_setImageWithURL:[NSURL URLWithString:self.matchInfo.guestTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    self.matchTopView.rightNameL.text = self.matchInfo.guestTeam.teamName;
    self.matchTopView.programmeNumL.text = [NSString stringWithFormat:@"%@个方案",@(self.matchInfo.threadCount)];
    self.matchTopView.followBtn.selected = self.matchInfo.hasFollowed;
    
    NSString *matchTime = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinute_Line:self.matchInfo.matchTime];
    switch (self.matchInfo.matchStatus) {
        case kLQMatchStatusNotStart:
            self.titleView.titleLabel.text = [NSString stringWithFormat:@"%@  VS  %@", stringNotNil(self.matchInfo.homeTeam.teamName), stringNotNil(self.matchInfo.guestTeam.teamName)];

            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  未开始", matchTime];;
            break;
        case kLQMatchStatusIng:
            self.titleView.titleLabel.text = [NSString stringWithFormat:@"%@  VS  %@", stringNotNil(self.matchInfo.homeTeam.teamName), stringNotNil(self.matchInfo.guestTeam.teamName)];

            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  进行中", matchTime];;
            break;
        case kLQMatchStatusFinished:{
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  已结束", matchTime];
            self.matchTopView.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(self.matchInfo.homeScore), @(self.matchInfo.guestScore)];
            
            self.titleView.titleLabel.text = [NSString stringWithFormat:@"%@  %@ : %@  %@", stringNotNil(self.matchInfo.homeTeam.teamName),
                                              @(self.matchInfo.homeScore), @(self.matchInfo.guestScore),
                                              stringNotNil(self.matchInfo.guestTeam.teamName)];
            break;
        }
        case kLQMatchStatusDelay:{
            self.titleView.titleLabel.text = [NSString stringWithFormat:@"%@  VS  %@", stringNotNil(self.matchInfo.homeTeam.teamName), stringNotNil(self.matchInfo.guestTeam.teamName)];
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  已延期", matchTime];
            break;
        }
        case kLQMatchStatusCancel:{
            self.titleView.titleLabel.text = [NSString stringWithFormat:@"%@  VS  %@", stringNotNil(self.matchInfo.homeTeam.teamName), stringNotNil(self.matchInfo.guestTeam.teamName)];
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  已取消", matchTime];
            break;
        }
        default:
            break;
    }
}


#pragma mark === network
- (void)getHeaderData
{
    LQMatchInfoReq *req = [[LQMatchInfoReq alloc] init];
    [req apendRelativeUrlWith:@(self.matchID).stringValue];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == kLQNetResponseSuccess) {
            self.matchInfo = [[LQMatchHeaderInfo alloc] initWith:res.data];
        }
        [self reloadHeaderView];
    } error:^(NSError *error) {
        
    }];
}

-(void)getMatchListDataIsRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.matchList.count;
    NSInteger limit = 10;
    LQMatchListReq *req = [[LQMatchListReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/planList/%@/%@", @(self.matchID), @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        [self.tableView.mj_footer endRefreshing];
        LQMatchListRes *res = (LQMatchListRes *)response;
        if (isRefresh) {
            self.matchList = [LQMatchListInfo objArrayWithDics:res.aData].mutableCopy;
        }else{
            [self.matchList addObjectsFromArray:[LQMatchListInfo objArrayWithDics:res.aData]];
        }
        
        if (self.matchList.count == 0) {
            self.tableView.tableFooterView = self.emptyView;
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.tableFooterView = self.emptyView;
    }];
}


#pragma mark ====  UITableViewDelegate、 UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.webViewModel.showType != kMatchWebViewShowTypeNone) {
        return 1;
    }
    return self.matchList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.webViewModel.showType >= kMatchWebViewShowTypeLive) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webcelllive"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.liveView];
        return cell;
    }
    if (self.webViewModel.showType >= kMatchWebViewShowTypeCompensate) { // 指标
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webcellindex"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.indexView];
        return cell;
    }
    
    if (self.webViewModel.showType >= kMatchWebViewShowTypeData) { // 分析
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webcellanalysis"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.analysisView];
        return cell;
    }
    
    static NSString *cellid = @"LQMatTableViewCellid";
    LQMatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LQMatTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellid];
    }
    @weakify(self)
    cell.persobAction = ^(LQMatchListInfo *dataObj) {
        LQPersonVC *vc = [[LQPersonVC alloc] init];
        vc.userID = @(dataObj.expert.userId);
        vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.expert.toJSON];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    cell.programmeAction = ^(LQMatchListInfo *dataObj) {
        LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
        vc.proID = @(dataObj.threadId);
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    LQMatchListInfo *matchInfo = [self.matchList safeObjectAtIndex:indexPath.row];
    [cell.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchInfo.expert.avatar] placeholderImage:LQPlaceholderIcon];
    cell.expertNameLabel.text = matchInfo.expert.nickname;
    cell.expertDescriptionLabel.text = matchInfo.expert.slogan;
    cell.straightLabel.hidden = matchInfo.expert.maxWin == 0;
    cell.straightLabel.text = [NSString stringWithFormat:@"%@连红", @(matchInfo.expert.maxWin)];

    cell.hitRateLabel.text = @((int)round(matchInfo.expert.hitRate * 100)).stringValue;
    cell.hitRateLabel.hidden = !matchInfo.expert.showHitRate;
    cell.hitDesLabel.text = @"命中率";
    cell.titleLabel.text = matchInfo.threadTitle;
    cell.timeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:matchInfo.publishTime];
    
    cell.lookNumbersLabel.text = [NSString stringWithFormat:@"已查看%@次", @(matchInfo.views)];
    cell.beanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(matchInfo.price)];

    BOOL showBean = (matchInfo.plock < kLQThreadPlockFinished) && (!matchInfo.purchased)&&(matchInfo.price>0);
    cell.beanView.hidden = !showBean;
    cell.lookButton.hidden = showBean;
    
    cell.hitRollBtn.hidden = YES;
    cell.matchStatusLabel.hidden = YES;
    cell.lookNumbersLabel.hidden = YES;
    switch (matchInfo.plock) {
        case kLQThreadPlockCanPurchase:{
            cell.lookNumbersLabel.hidden = NO;
            break;
        }
        case kLQThreadPlockUnderway:{
            cell.matchStatusLabel.text = @"进行中";
            cell.matchStatusLabel.textColor = [UIColor flsMainColor];
            cell.matchStatusLabel.hidden = NO;
            break;
        }
        case kLQThreadPlockFinished:{
            cell.hitRollBtn.hidden = NO;
            cell.hitRollBtn.selected = !matchInfo.isWin;
            break;
        }
        case kLQThreadPlockCancel:{
            cell.matchStatusLabel.hidden = NO;
            cell.matchStatusLabel.text = @"已取消";
            cell.matchStatusLabel.textColor = [UIColor flsCancelColor];
            break;
        }
        default:
            break;
    }

    cell.dataObj = matchInfo;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.webViewModel.showType != kMatchWebViewShowTypeNone) {
        return UIDeviceScreenHeight - kLQNavANDStatusBarHeight - kMCSPageingViewSizeHeight;
    }
    LQMatchListInfo *matchInfo = [self.matchList safeObjectAtIndex:indexPath.row];
    if (matchInfo.cacheHeight <= CGFLOAT_MIN) {
        matchInfo.cacheHeight = [LQMatTableViewCell staticHeight];
        matchInfo.cacheHeight += [matchInfo.threadTitle sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
    }
    return matchInfo.cacheHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kMCSPageingViewSizeHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kMCSPageingViewSizeHeight)];
    [sectionHeader addSubview:self.pageView];
    [self.pageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    return sectionHeader;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.webViewModel.showType != kMatchWebViewShowTypeNone) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LQMatchListInfo *matchInfo = [self.matchList safeObjectAtIndex:indexPath.row];
    LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
    vc.proID = @(matchInfo.threadId);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.tableView) {
        return;
    }
    NSInteger offset = self.tableView.contentOffset.y;
    CGFloat judgementOffset = HeaderViewHeight__ - kLQNavANDStatusBarHeight;
 
    if(offset<=0){
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }else if (offset>= judgementOffset && self.webViewModel.showType != kMatchWebViewShowTypeNone){
        [scrollView setContentOffset:CGPointMake(0, judgementOffset)];
    }
    
    self.titleView.alpha = offset/judgementOffset;
    
    if (self.webViewModel.showType == kMatchWebViewShowTypeNone) {
        if (offset > judgementOffset) {
            self.tableView.contentInset = UIEdgeInsetsMake(kLQNavANDStatusBarHeight, 0, 0, 0);
        }else{
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
        return;
    }else{
        self.tableView.contentInset = UIEdgeInsetsZero;
    }

    _analysisView.judgementOffset = offset;
    _indexView.judgementOffset = offset;
    _liveView.judgementOffset = offset;
    
    if (offset < judgementOffset) {
        [_analysisView disEnableWebViewScrolled];
        [_indexView disEnableWebViewScrolled];
        [_liveView disEnableWebViewScrolled];
    }else{
        [_analysisView enableWebViewScrolled];
        [_indexView enableWebViewScrolled];
        [_liveView enableWebViewScrolled];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.tableView) {
        return;
    }
    
    if (self.webViewModel.showType == kMatchWebViewShowTypeNone) {
        return;
    }
    
    NSInteger offset = scrollView.contentOffset.y;
    CGFloat judgementOffset = HeaderViewHeight__ - kLQStatusBarHeight;

    if (offset>=0 && offset< judgementOffset *.5) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [scrollView setContentOffset:CGPointMake(0, judgementOffset) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark ==========

#pragma mark   === getter

-(MCSPageingView *)pageView
{
    if (!_pageView) {
        @weakify(self)
        _pageView = [[MCSPageingView alloc] initWithTitles:@[@"方案", @"分析", @"指数", @"直播"]
                                               selectBlock:^BOOL(MCSPageingView *pageingView, NSUInteger index) {
                                                   
                                                   self_weak_.tableView.mj_footer.hidden = index > 0;
                                                   // 这里必须在不需要的时候创建一个大小为零的FooterView，避免手势响应迟钝
                                                   if (index > 0) {
                                                       self_weak_.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                                                   }
                                                   
                                                   switch (index) {
                                                       case 0:{
                                                           [self_weak_.webViewModel updateShowType:kMatchWebViewShowTypeNone];
                                                           if (self_weak_.matchList.count == 0) {
                                                               self_weak_.tableView.tableFooterView = self_weak_.emptyView;
                                                           }
                                                           break;
                                                       }
                                                       case 1:{
                                                           [self_weak_.webViewModel updateShowType:kMatchWebViewShowTypeReport - self_weak_.analysisView.swichCtrl.on];
                                                           self_weak_.analysisView.urlStrl = self_weak_.webViewModel.webUrl;
                                                           break;
                                                       }
                                                       case 2:{
                                                           [self_weak_.webViewModel updateShowType:kMatchWebViewShowTypeTotalScore - self_weak_.indexView.swichCtrl.on];
                                                           self_weak_.indexView.urlStrl = self_weak_.webViewModel.webUrl;
                                                           break;
                                                       }
                                                       case 3:{
                                                           [self_weak_.webViewModel updateShowType:(kMatchWebViewShowTypeLive)];
                                                           self_weak_.liveView.urlStrl = self_weak_.webViewModel.webUrl;
                                                           break;
                                                       }
                                                       default:
                                                           break;
                                                   }
                                                   [self_weak_.tableView reloadData];

                                                   return YES;
                                               }];
    }
    return _pageView;
}

-(LQMatchWebView *)analysisView
{
    if (!_analysisView) {
        _analysisView = [[LQMatchWebView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight -kLQNavANDStatusBarHeight -kMCSPageingViewSizeHeight)];
        [_analysisView.swichCtrl updateSwithOnTitle:@"数据" offTitle:@"情报"];
        
        @weakify(self)
        _analysisView.swichCtrl.swichAction = ^(BOOL isOn) {
            [self_weak_.webViewModel updateShowType:kMatchWebViewShowTypeReport - isOn];
            self_weak_.analysisView.urlStrl = self_weak_.webViewModel.webUrl;
        };
    }
    return _analysisView;
}

-(LQMatchWebView *)indexView
{
    if (!_indexView) {
        _indexView = [[LQMatchWebView alloc] initWithFrame:CGRectMake(0, 0,UIDeviceScreenWidth, UIDeviceScreenHeight -kLQNavANDStatusBarHeight -kMCSPageingViewSizeHeight)];
        [_indexView.swichCtrl updateSwithOnTitle:@"欧赔/亚盘" offTitle:@"大小球"];
        _indexView.linkViewCtrl = self;
        
        @weakify(self)
        _indexView.swichCtrl.swichAction = ^(BOOL isOn) {
            [self_weak_.webViewModel updateShowType:kMatchWebViewShowTypeTotalScore - isOn];
            self_weak_.indexView.urlStrl = self_weak_.webViewModel.webUrl;
        };
    }
    return _indexView;
}

-(LQMatchWebView *)liveView
{
    if (!_liveView) {
        _liveView = [[LQMatchWebView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight -kLQNavANDStatusBarHeight -kMCSPageingViewSizeHeight)];
        [_liveView hiddenSwichCtrl];
    }
    return _liveView;
}

-(MatchDetailsTopV *)matchTopView
{
    if (!_matchTopView) {
        _matchTopView = [[[NSBundle mainBundle] loadNibNamed:@"MatchDetailsTopV" owner:self options:nil] lastObject];
        _matchTopView.frame = CGRectMake(0, 0, UIDeviceScreenWidth, HeaderViewHeight__);
    }
    return _matchTopView;
}

-(UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UIDeviceScreenHeight - kMCSPageingViewSizeHeight - HeaderViewHeight__)];
        [self showEmptyViewInView:_emptyView imageName:@"empty_2" title:@"暂无方案"];
        _emptyView.userInteractionEnabled = NO;
    }
    return _emptyView;
}

@end
