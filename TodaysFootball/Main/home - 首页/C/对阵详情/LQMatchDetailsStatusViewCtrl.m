//
//  LQMatchDetailsStatusViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMatchDetailsStatusViewCtrl.h"
#import "MatchDetailsTopV.h"
#import "LQMatchStatusWebView.h"
#import "MCSPageingView.h"
#import "LQOptionManager.h"
#import "LQMatchHeaderInfo.h"
#import "LQMatchInfoReq.h"

@interface LQMatchDetailsStatusViewCtrl ()

// 表头
@property (nonatomic, strong) MatchDetailsTopV * matchTopView;
// 分栏
@property (nonatomic, strong) MCSPageingView * pageView;

// 数据
@property (nonatomic, strong) LQMatchStatusWebView * dataView;
//  情报
@property (nonatomic, strong) LQMatchStatusWebView * intelligenceView;
// 直播
@property (nonatomic, strong) LQMatchStatusWebView * liveView;
// 无数据空白样式
@property (nonatomic, strong) UIView * emptyView;

@end

@implementation LQMatchDetailsStatusViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    [self reloadHeaderView];
    [self getHeaderData];
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
   
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 225)];
    [header addSubview:self.matchTopView];
    [self.view addSubview:header];
    
    [self.view addSubview:self.pageView];
    [_pageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_pageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_pageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:header];
    
    self.dataView.urlStrl = [NSString stringWithFormat:@"%@/match/%@/data%@", LQWebURL , @(self.matchInfo.matchInfoId), LQWebPramSuffix];
    
    @weakify(self)
    [[self.matchTopView.backBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_.navigationController popViewControllerAnimated:YES];
    }];

    
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
    
}


- (void)reloadHeaderView
{
    // 后期需要全部转成对象、并且不要直接用 LQNetResponse的子类传值赋值
    self.matchTopView.titleL.text = self.matchInfo.leagueMatch.leagueName;
    [self.matchTopView.leftIma sd_setImageWithURL:[NSURL URLWithString:self.matchInfo.homeTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    self.matchTopView.leftNameL.text = self.matchInfo.homeTeam.teamName;
    [self.matchTopView.rightIma sd_setImageWithURL:[NSURL URLWithString:self.matchInfo.guestTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
    self.matchTopView.rightNameL.text = self.matchInfo.guestTeam.teamName;
    self.matchTopView.followBtn.selected = self.matchInfo.hasFollowed;
    
    NSString *matchTime = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinute_Line:self.matchInfo.matchTime];
    switch (self.matchInfo.matchStatus) {
        case kLQMatchStatusNotStart:
            
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  未开始", matchTime];;
            break;
        case kLQMatchStatusIng:
            
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  进行中", matchTime];;
            break;
        case kLQMatchStatusFinished:{
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  已结束", matchTime];
            self.matchTopView.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(self.matchInfo.homeScore), @(self.matchInfo.guestScore)];
            
            break;
        }
        case kLQMatchStatusDelay:{
            self.matchTopView.timeL.text = [NSString stringWithFormat:@"%@  已延期", matchTime];
            break;
        }
        case kLQMatchStatusCancel:{
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


-(MatchDetailsTopV *)matchTopView
{
    if (!_matchTopView) {
        _matchTopView = [[[NSBundle mainBundle] loadNibNamed:@"MatchDetailsTopV" owner:self options:nil] lastObject];
        _matchTopView.frame = CGRectMake(0, 0, UIDeviceScreenWidth, 225);
        _matchTopView.programmeNumL.hidden = YES;
    }
    return _matchTopView;
}


-(MCSPageingView *)pageView
{
    if (!_pageView) {
        @weakify(self)
        _pageView = [[MCSPageingView alloc] initWithTitles:@[@"数据", @"情报", @"直播"]
                                               selectBlock:^BOOL(MCSPageingView *pageingView, NSUInteger index) {
                                                   switch (index) {
                                                       case 0:{
                                                           self_weak_.dataView.urlStrl = [NSString stringWithFormat:@"%@/match/%@/data%@", LQWebURL , @(self.matchInfo.matchInfoId), LQWebPramSuffix];
                                                           break;
                                                       }
                                                       case 1:{
                                                           self_weak_.intelligenceView.urlStrl = [NSString stringWithFormat:@"%@/match/%@/report%@", LQWebURL, @(self.matchInfo.matchInfoId), LQWebPramSuffix];
                                                           break;
                                                       }
                                                       case 2:{
                                                           self_weak_.liveView.urlStrl = [NSString stringWithFormat:@"%@/match/%@/live%@", LQWebURL, @(self.matchInfo.matchInfoId), LQWebPramSuffix];
                                                           break;
                                                       }
                                                       default:
                                                           break;
                                                   }
                                                   
                                                   self_weak_.dataView.hidden = !(index == self_weak_.dataView.tag);
                                                   self_weak_.intelligenceView.hidden = !(index == self_weak_.intelligenceView.tag);
                                                   self_weak_.liveView.hidden = !(index == self_weak_.liveView.tag);
                                                   return YES;
                                               }];
    }
    return _pageView;
}


-(LQMatchStatusWebView *)dataView
{
    if (!_dataView) {
        _dataView = [[LQMatchStatusWebView alloc] init];
        _dataView.tag = 0;
        [self.view addSubview:_dataView];
        [_dataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_dataView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pageView];
    }
    
    return _dataView;
}

- (LQMatchStatusWebView *)intelligenceView
{
    if (!_intelligenceView) {
        _intelligenceView = [[LQMatchStatusWebView alloc] init];
        _intelligenceView.tag = 1;
        [self.view addSubview:_intelligenceView];
        [_intelligenceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_intelligenceView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pageView];
    }
    return _intelligenceView;
}

-(LQMatchStatusWebView *)liveView
{
    if (!_liveView) {
        _liveView = [[LQMatchStatusWebView alloc] init];
        _liveView.tag = 2;
        [self.view addSubview:_liveView];
        [_liveView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_liveView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pageView];
    }
    return _liveView;
}

@end
