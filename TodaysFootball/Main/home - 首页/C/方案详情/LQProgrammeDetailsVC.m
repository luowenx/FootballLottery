//
//  LQProgrammeDetailsVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQProgrammeDetailsVC.h"
#import "LQChooseCouponPanel.h"
#import "LQLoginMainViewCtrl.h"
#import "LQMatchDetailsVC.h"
#import "LQMatchDetailsStatusViewCtrl.h"
#import "LQRechargeVC.h"
#import "LQPersonVC.h"
#import "LQBalanceVC.h"

#import "LQPayView.h"
#import "LQDetailsTopV.h"
#import "LQPlanDetailCell.h"
#import "LQPanWebFooterView.h"
#import "LQRecommendTimerView.h"

#import "LQTeamInfo.h"
#import "LQPlayVoObj.h"
#import "LQExpertDetail.h"
#import "LQPlanDetailObj.h"
#import "LQMatchDetailObj.h"
#import "LQAvailableCoupon.h"
#import "LQMatchHeaderInfo.h"

#import "LQOptionManager.h"
#import "LQPlanDetailReq.h"

#import <UShareUI/UShareUI.h>
#import "LQPlanDetailHeader.h"
#import "LQAppConfiger.h"

@interface LQProgrammeDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
/**************************** 视图 ****************************/
@property (nonatomic, strong) UITableView *mainTableV;
@property (nonatomic, strong) LQRecommendTimerView *timerView; //  计时
@property (nonatomic, strong) LQPlanWebFooterView *footerView;   //   content
@property (nonatomic, strong) LQPayView *payView; // 购买按钮
@property (nonatomic, strong) UIButton * rightBtn;   // 收藏按钮
@property (nonatomic, strong) UIButton *shareBtn;   // 分享按钮

/****************************** 数据 ******************************/
@property (nonatomic, strong) LQPlanDetailObj * detailObj;
// 数据展示类型
@property (nonatomic) LQPlanDetailShowType showType;
// 所选中的优惠券
@property (nonatomic, strong) LQAvailableCoupon * selectedCoupon;
@end

@implementation LQProgrammeDetailsVC
{
    UIView *navgetionBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self getNetData];
    
    @weakify(self)
    [[RACObserve(userManager, currentUser) skip:1] subscribeNext:^(id x) {
        [self_weak_ getNetData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)getNetData
{
    [self.view showActivityViewWithTitle:@"加载中"];
    LQPlanDetailReq *req = [[LQPlanDetailReq alloc] init];
    [req apendRelativeUrlWith:self.proID.stringValue];
    [req requestWithCompletion:^(id response) {
        LQPlanDetailRes *res = (LQPlanDetailRes *)response;
        if (res.ret != 0) {
            [self.view hiddenActivity];
            return ;
        }
        self.detailObj = [[LQPlanDetailObj alloc] initWith:res.data];
        // 刷新展示数据的类型
        [self reloadShowType];
        // 标记优惠券
        if (self.detailObj.couponList.count>0) {
            self.selectedCoupon = self.detailObj.couponList.firstObject;
        }else{
            self.selectedCoupon = nil;
        }
        
        // 根据 showType 分情况显示数据
        if (self.detailObj.showContent && self.detailObj.content.length > 0) {
            [self.footerView loadWithHTMLString:self.detailObj.content baseUrl:nil];
        }else{
            [self.view hiddenActivity];
            [self.mainTableV reloadData];
            self.mainTableV.hidden = NO;
        }
    } error:^(NSError *error) {
        if (error.code == kLQNetErrorCodeNotReachable) {
            [self.view hiddenActivityWithTitle:nil];
            if (self.detailObj) {
                return;
            }
            UIView *emptyView = [self showEmptyViewInView:self.view imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
            [emptyView removeFromSuperview];
            [self.view insertSubview:emptyView belowSubview:navgetionBar];
            [emptyView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }else{
            [self.view hiddenActivityWithTitle:@"加载失败"];
        }
    }];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    [self getNetData];
}

- (void)initUI
{
    self.navigationController.navigationBar.hidden = YES;
    navgetionBar = [UIView newAutoLayoutView];
    navgetionBar.backgroundColor = [UIColor flsMainColor];
    [self.view addSubview:navgetionBar];
    [navgetionBar autoSetDimension:ALDimensionHeight toSize:kLQNavANDStatusBarHeight];
    [navgetionBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [navgetionBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [navgetionBar autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareBtn = shareBtn;
    [shareBtn setImage:imageWithName(@"share") forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [navgetionBar addSubview:shareBtn];
    [shareBtn autoSetDimensionsToSize:CGSizeMake(44, kLQNavHeight)];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _rightBtn = rightBtn;
    [rightBtn setImage:imageWithName(@"collected") forState:(UIControlStateSelected)];
    [rightBtn setImage:imageWithName(@"collection") forState:(UIControlStateNormal)];
    [navgetionBar addSubview:rightBtn];
    [rightBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:shareBtn];
    [rightBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shareBtn withOffset:-10];
    
    UIButton *backBtn = [UIButton newAutoLayoutView];
    [backBtn setImage:imageWithName(@"return") forState:(UIControlStateNormal)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    [navgetionBar addSubview:backBtn];
    [backBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [backBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:shareBtn];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [backBtn addTarget:self action:@selector(onBack) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"方案详情";
    titleLabel.font = [UIFont lqsFontOfSize:34 isBold:YES];
    [navgetionBar addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:shareBtn];

    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.mainTableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTableV.delegate = self;
    self.mainTableV.dataSource = self;
    self.mainTableV.separatorStyle = UITableViewCellEditingStyleNone;
    self.mainTableV.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mainTableV.estimatedRowHeight = 0;
        self.mainTableV.estimatedSectionFooterHeight = 0;
        self.mainTableV.estimatedSectionHeaderHeight = 0;
        self.mainTableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.mainTableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.mainTableV];
    [self.mainTableV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQNavANDStatusBarHeight];
    [self.mainTableV autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.mainTableV autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.mainTableV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-20];/* group 会使底下有20pt的留白 */
    self.mainTableV.hidden = YES;
    
    self.payView = [LQPayView newAutoLayoutView];
    self.payView.hidden = YES;
    [self.view addSubview:self.payView];
    [self.payView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.payView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.payView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    
    @weakify(self)
    // 选择优惠券
    self.payView.chooseDiscount = ^{
        @strongify(self)
        LQChooseCouponPanel *panel = [[LQChooseCouponPanel alloc] init];
        panel.couponList = self.detailObj.couponList;
        NSInteger index = [self.detailObj.couponList indexOfObject:self.selectedCoupon];
        if (index == NSNotFound) {
            index = self.detailObj.couponList.count;
        }
        panel.selectedIndex = index;
        panel.chooseCouoon = ^(LQAvailableCoupon *coupon) {
            self.selectedCoupon = coupon;
        };
        [self presentViewController:panel animated:YES completion:^{ }];
    };
    
    // 购买流程
    self.payView.pay = ^{
        [self_weak_ pay];
    };

    self.timerView.completeTimer = ^{ /// 倒计时完成回调
        self_weak_.detailObj.canPurchase = NO;
        [self_weak_ reloadShowType];
        [self_weak_.mainTableV reloadData];
        [LQJargon hiddenJargon:@"此方案已禁止售卖" delayed:1];
    };
    
    // 收藏
    [[rightBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *collectionBtn) {
        if (!userManager.isLogin) {
            [LQOptionManager loginMainInTarge:self_weak_]; return ;
        }
        
        [self_weak_.view showActivityViewWithTitle:nil];
        [LQOptionManager planisFavorite:collectionBtn.isSelected
                               threadId:@(self_weak_.detailObj.threadId).stringValue
                               callBack:^(BOOL success, NSError *error) {
                                   if (success) {
                                       [self_weak_.view hiddenActivityWithTitle:@"操作成功"];
                                       collectionBtn.selected = !collectionBtn.isSelected;
                                       self_weak_.detailObj.hasFavorite = collectionBtn.selected;
                                   }else{
                                       [self_weak_.view hiddenActivityWithTitle:@"操作失败"];
                                   }
        }];
    }];
    
    // 分享
    [[shareBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
            NSString *title = [NSString stringWithFormat:@"来看看%@专家对这场比赛的预测推荐吧", self_weak_.detailObj.expertData.nickname];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                                     descr:self_weak_.detailObj.title
                                                                                 thumImage:imageWithName(@"appIcon60x60")];
            shareObject.webpageUrl = [NSString stringWithFormat:@"%@/plans/%@%@", LQWebURL, self_weak_.proID, LQWebPramSuffix];
            messageObj.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                messageObject:messageObj
                                        currentViewController:self_weak_
                                                   completion:^(id result, NSError *error) {
                                                       if (error) {
                                                           UMSocialLogInfo(@"************Share fail with error %@*********",error);
                                                       }else {
                                                           if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                               UMSocialShareResponse *resp = result;
                                                               //分享结果消息
                                                               UMSocialLogInfo(@"response message is %@",resp.message);
                                                               //第三方原始返回的数据
                                                               UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                                               
                                                           }else{
                                                               UMSocialLogInfo(@"response data is %@",result);
                                                           }
                                                       }
                                                   }];
        }];
    }];
    
    // 根据优惠券逻辑
    [RACObserve(self, selectedCoupon) subscribeNext:^(id x) {
        LQAvailableCoupon *coupon = (LQAvailableCoupon *)x;
        
        [self_weak_.payView setColorbean:self_weak_.detailObj.price discount:coupon];
        
    }];
}

-(void)reloadShowType
{
    self.rightBtn.selected = self.detailObj.hasFavorite;

    if (self.detailObj.showContent) { // 不显示购买按钮、显示方案详情
        self.payView.hidden = YES;
        self.showType = LQPlanDetailShowTypeShowContent;
    }else{
        if (self.detailObj.canPurchase) {// 可以购买、显示倒计时
            if (self.detailObj.plock == kLQThreadPlockUnderway) { // 提示有比赛已经开始、可继续购买
                self.showType = LQPlanDetailShowTypeBeginTips;
                self.payView.hidden = NO;
                [self.timerView setShowType:self.showType];
                NSDate *endDate = [self.detailObj.saleEndTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval endTimeInterval = endDate.timeIntervalSince1970 - NSDate.date.timeIntervalSince1970;
                if (endTimeInterval <= 0) { // 倒计时结束了，说明只有一场比赛
                    self.payView.hidden = NO;
                    self.showType = LQPlanDetailShowTypeUnderway;
                    [self.payView setShowType:(self.showType)];
                    [self.timerView setShowType:self.showType];
                }else{
                    [self reloadTimerView];
                }
            } else{
                // 比赛未开始、显示倒计时
                self.payView.hidden = NO;

                self.showType = LQPlanDetailShowTypeCountdown;
                [self.timerView setShowType:self.showType];
                [self reloadTimerView];
            }
        }else{// 方案售卖已结束、购买按钮灰色
            self.payView.hidden = NO;
            self.showType = LQPlanDetailShowTypeUnderway;
            [self.payView setShowType:(self.showType)];
            [self.timerView setShowType:self.showType];
        }
    }
}

#pragma mark ====== UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailObj.matchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"LQPlanDetailCelliD";
    LQPlanDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LQPlanDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    @weakify(self)
    cell.lookMatch = ^(LQMatchDetailObj *dataObj) {
        LQMatchDetailsVC *matchVC = nil;
        
        if (LQAppConfiger.shareInstance.appStatus) {
            matchVC = [[LQMatchDetailsVC alloc] init];
        }else{
            matchVC = (LQMatchDetailsVC *)[[LQMatchDetailsStatusViewCtrl alloc] init];
        }
        matchVC.matchID = dataObj.matchInfoId;
        matchVC.matchInfo = ({
            LQMatchHeaderInfo *matchInfo = [[LQMatchHeaderInfo alloc] init];
            matchInfo.guestScore = dataObj.guestScore;
            matchInfo.guestTeam = dataObj.guestTeam;
            matchInfo.homeScore = dataObj.homeScore;
            matchInfo.homeTeam = dataObj.homeTeam;
            matchInfo.matchInfoId = dataObj.matchInfoId;
            matchInfo.matchStatus = dataObj.matchStatus;
            matchInfo.matchTime = dataObj.matchTime;
            matchInfo.threadCount = dataObj.threadCount;
            matchInfo.todaysfootballCategoryId = dataObj.categoryId;
            
            matchInfo.leagueMatch = ({
                LQLeagueObj *leagueMatch = [[LQLeagueObj alloc] init];
                leagueMatch.leagueId = dataObj.leagueId;
                leagueMatch.leagueName = dataObj.leagueName;
                leagueMatch;
            });
            
            matchInfo;
        });
        [self_weak_.navigationController pushViewController:matchVC animated:YES];
    };
    
    cell.open = ^(LQMatchDetailObj* dataObj) {
        LQPlayVoObj *voObj = dataObj.playVoList.firstObject;
        voObj.isOpen = YES;
        [self_weak_.mainTableV reloadData];
    };
    
    LQMatchDetailObj *matchDetail = [self.detailObj.matchList safeObjectAtIndex:indexPath.row];
    cell.dataObj = matchDetail;

    cell.timeStatusView.leagueLabel.text = matchDetail.leagueName;
    cell.timeStatusView.startTimeLabel.text = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinute_Line:matchDetail.matchTime];
    
    switch (matchDetail.matchStatus) {
        case kLQMatchStatusFinished:{
            //已结束
            [cell.timeStatusView.statusButton setTitle:@"已结束" forState:(UIControlStateNormal)];
            [cell.timeStatusView.statusButton setTitleColor:UIColorFromRGB(0xa2a2a2) forState:(UIControlStateNormal)];
            cell.flatLabel.text = [NSString stringWithFormat:@"%@ : %@", @(matchDetail.homeScore),@(matchDetail.guestScore)];
            break;
        }
        case kLQMatchStatusNotStart:{
            //未开始
            [cell.timeStatusView.statusButton setTitle:@"未开始" forState:(UIControlStateNormal)];
            [cell.timeStatusView.statusButton setTitleColor:[UIColor flsMainColor2] forState:(UIControlStateNormal)];
            cell.flatLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusIng:{
            //进行中
            [cell.timeStatusView.statusButton setTitle:@"进行中" forState:(UIControlStateNormal)];
            [cell.timeStatusView.statusButton setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];

            cell.flatLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusDelay:{
            //已延期
            [cell.timeStatusView.statusButton setTitle:@"已延期" forState:(UIControlStateNormal)];
            [cell.timeStatusView.statusButton setTitleColor:[UIColor flsDelayColor] forState:(UIControlStateNormal)];

            cell.flatLabel.text = @"VS";
            break;
        }
        case kLQMatchStatusCancel:{
            //已取消
            [cell.timeStatusView.statusButton setTitle:@"已取消" forState:(UIControlStateNormal)];
            [cell.timeStatusView.statusButton setTitleColor:[UIColor flsCancelColor] forState:(UIControlStateNormal)];

            cell.flatLabel.text = @"VS";
            break;
        }
        default:
            break;
    }
    
    LQPlayVoObj *voObj = matchDetail.playVoList.firstObject;
    if (voObj) {
        cell.tipsLabel1.text = voObj.extraOddsDesc;
        //  赛事状态
        cell.concedLabel.text = stringNotNil(voObj.playName);
        cell.concedValueLabel.text = stringNotNil(voObj.concede);
        [cell.homeIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchDetail.homeTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
        cell.homeLabel.text = stringNotNil(matchDetail.homeTeam.teamName);
        
        [cell.guestIconView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:matchDetail.guestTeam.teamIcon] placeholderImage:LQPlaceholderTeamIcon];
        cell.guestLabel.text = stringNotNil(matchDetail.guestTeam.teamName);
        
        LQItemVo *voHome = [voObj.itemVoList safeObjectAtIndex:0];
        cell.homeVictoryView.playTitleLabel.text = stringNotNil(voHome.playItemName);
        cell.homeVictoryView.playValueLabel.text = [NSString stringWithFormat:@"%.2f", voHome.odds];
        cell.homeVictoryView.hookImageView.hidden = (!voHome.isMatchResult) || (matchDetail.matchStatus != 3);
        cell.homeVictoryView.hitImageView.hidden = YES;
        
        LQItemVo *voFlat = [voObj.itemVoList safeObjectAtIndex:1];
        cell.flatView.playTitleLabel.text = stringNotNil(voFlat.playItemName);
        cell.flatView.playValueLabel.text = [NSString stringWithFormat:@"%.2f", voFlat.odds];
        cell.flatView.hookImageView.hidden = (!voFlat.isMatchResult) || (matchDetail.matchStatus != 3);
        cell.flatView.hitImageView.hidden = YES;
        
        LQItemVo *voGuest = [voObj.itemVoList safeObjectAtIndex:2];
        cell.guestVictoryView.playTitleLabel.text = stringNotNil(voGuest.playItemName);
        cell.guestVictoryView.playValueLabel.text = [NSString stringWithFormat:@"%.2f", voGuest.odds];
        cell.guestVictoryView.hookImageView.hidden = (!voGuest.isMatchResult) ||(matchDetail.matchStatus != 3);
        cell.guestVictoryView.hitImageView.hidden = matchDetail.matchStatus != 3;
        
        [cell.homeVictoryView setOutcome:0 isRecommend:voHome.isRecommend];
        [cell.flatView setOutcome:1 isRecommend:voFlat.isRecommend];
        [cell.guestVictoryView setOutcome:2 isRecommend:voGuest.isRecommend];
        
        if (voHome.isRecommend == voFlat.isRecommend == 1) {
            cell.playLine1.hidden = NO;
            cell.playLine1.backgroundColor = [UIColor whiteColor];
        }else if(voHome.isRecommend == voFlat.isRecommend == 0){
            cell.playLine1.hidden = NO;
            cell.playLine1.backgroundColor = [UIColor flsSpaceLineColor];
        }else{
            cell.playLine1.hidden = YES;
        }
        
        if (voFlat.isRecommend == voGuest.isRecommend == 1) {
            cell.playLine2.hidden = NO;
            cell.playLine2.backgroundColor = [UIColor whiteColor];
        }else if (voFlat.isRecommend == voGuest.isRecommend == 0){
            cell.playLine2.hidden = NO;
            cell.playLine2.backgroundColor = [UIColor flsSpaceLineColor];
        } else{
            cell.playLine2.hidden = YES;
        }
        
        BOOL isHit = NO;
        if (voHome.isMatchResult && voHome.isRecommend) {
            isHit = YES;
        }
        if (voFlat.isMatchResult && voFlat.isRecommend) {
            isHit = YES;
        }
        if (voGuest.isMatchResult && voGuest.isRecommend) {
            isHit = YES;
        }

        if (self.detailObj.showContent) {
            if (isHit) {
                cell.guestVictoryView.hitImageView.image = imageWithName(@"已中");
            }else{
                cell.guestVictoryView.hitImageView.image = imageWithName(@"未中");
            }
        }else{
            cell.guestVictoryView.hitImageView.image = nil;
        }
        
        // 倍率
        // 这里不绑定视图逻辑会更加复杂
        cell.oddsView.oddData = voObj.extraOddsList;
        
        BOOL isOpen = matchDetail.matchStatus != kLQMatchStatusFinished;
        if (!isOpen) { // 已经是open 便不能更改
            isOpen = voObj.isOpen;
        }
        //已经结束的比赛才直接显示倍率表
        cell.oddsView.open = isOpen;
        cell.tipsImageView.hidden = isOpen;
      }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LQDetailsTopV *v = [[NSBundle mainBundle] loadNibNamed:@"LQDetailsTopV" owner:nil options:nil].lastObject;
    v.frame = CGRectMake(0, 0, UIDeviceScreenWidth, 140);
    v.titleL.text = stringNotNil(self.detailObj.title);
    v.timeL.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:self.detailObj.publishTime];
    [v.headIma sd_setImageWithURL:[NSURL URLWithString:self.detailObj.expertData.avatar] placeholderImage:LQPlaceholderIcon];
    v.nameL.text = stringNotNil(self.detailObj.expertData.nickname);
    v.cardL.text = stringNotNil(self.detailObj.expertData.slogan);

    v.hitStatusBtn .hidden = self.detailObj.plock != kLQThreadPlockFinished;
    v.hitStatusBtn.selected = !self.detailObj.isWin;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
    v.headIma.userInteractionEnabled = YES;
    [v.headIma addGestureRecognizer:tap];
    
    v.followBtn.selected = self.detailObj.expertData.hasFollowed;
    v.followBtn.backgroundColor = v.followBtn.selected ? UIColorFromRGB(0xa3a3a3) : [UIColor flsMainColor] ;
    [v.followBtn addTarget:self action:@selector(followExpert:) forControlEvents:(UIControlEventTouchUpInside)];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 265;
    LQMatchDetailObj *matchDetail = [self.detailObj.matchList safeObjectAtIndex:indexPath.row];
    LQPlayVoObj *voObj = matchDetail.playVoList.firstObject;
    if (voObj) {
        NSInteger lineNum = voObj.extraOddsList.count;
        CGFloat itemHeight = lqPointConvertInScreenWidth4EQScale(57.5);
        BOOL isOpen = matchDetail.matchStatus != 3;
        if (!isOpen) { // 已经是open 便不能更改
            isOpen = voObj.isOpen;
        }
        cellHeight += isOpen ? lineNum * itemHeight : 0;
    }
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat cellHeight = 127;
    cellHeight += [self.detailObj.title sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
    return cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (self.showType) {
        case LQPlanDetailShowTypeUnknown:
        case LQPlanDetailShowTypeShowContent:
            return self.footerView;
        case LQPlanDetailShowTypeCountdown:
        case LQPlanDetailShowTypeBeginTips:
        case LQPlanDetailShowTypeUnderway:{
            self.timerView.frame = CGRectMake(0, 0, UIDeviceScreenWidth, [self.timerView totalHeight]);
            return self.timerView;
        }
        default:  return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (self.showType) {
        case LQPlanDetailShowTypeUnknown:
        case LQPlanDetailShowTypeShowContent:{
            return [self.footerView totalHeight];
        }
        case LQPlanDetailShowTypeCountdown:
        case LQPlanDetailShowTypeBeginTips:
        case LQPlanDetailShowTypeUnderway:{
            return [self.timerView totalHeight];
        }
        default:
            return 0.1;
    }
}

#pragma mark ===  action

-(void)followExpert:(UIButton *)sender
{
    if (!userManager.isLogin) {
        [LQOptionManager loginMainInTarge:self];return;
    }
    [self.view showActivityViewWithTitle:nil];
    [LQOptionManager followExpertCurrentisFollowed:sender.isSelected
                                      expertUserId:stringNotNil(@(self.detailObj.expertData.userId).stringValue)
                                          callBack:^(BOOL success, NSError *error) {
                                              if (success) {
                                                  [self.view hiddenActivityWithTitle:@"操作成功"];
                                                  sender.selected = !sender.isSelected;
                                                  [sender setBackgroundColor:sender.isSelected?UIColorFromRGB(0xf2f2f2):[UIColor flsMainColor]];
                                                  self.detailObj.expertData.hasFollowed = sender.isSelected;
                                              }else{
                                                  [self.view hiddenActivityWithTitle:@"操作失败"];
                                              }
                                          }];
}

- (void)doTap{
    LQPersonVC *vc = [[LQPersonVC alloc] init];
    vc.userID = @(self.detailObj.expertData.userId);
    vc.expertDetail = self.detailObj.expertData;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pay
{
    @weakify(self)
    // 登录检查
    if (!userManager.isLogin) {
        [LQOptionManager loginMainInTarge:self];
        return;
    }
    
    // 检查彩豆是否足够
    NSInteger colorbean = self.detailObj.price;
    if (self.selectedCoupon.used) {
        colorbean = self.selectedCoupon.realCost;
    }
    
    if (self.detailObj.colorbean < colorbean) {
        LQRechargeVC *recharVC = [[LQRechargeVC alloc] initWithCommitPop:YES];
        [self.navigationController pushViewController:recharVC animated:YES];
        return ;
    }

    [self alertViewShowWithTitle:nil
                               message:@"是否购买该方案？"
                                cancel:@"取消"
                                 other:@"确定"
                          clickedBlock:^(BOOL isTrue) {
                              if (!isTrue) {return ;}
                              // 开始购买
                              [self_weak_.view showActivityViewWithTitle:@"正在购买"];
                              [LQOptionManager payPlanThreadId:@(self_weak_.detailObj.threadId).stringValue
                                                      couponId:self_weak_.selectedCoupon.userCouponId
                                                         price:@(self_weak_.detailObj.price).stringValue
                                                      callBack:^(BOOL success, NSError *error) {
                                                          if (success) {
                                                              [self_weak_.view hiddenActivityWithTitle:@"购买成功"];
                                                              // 因为返回用户信息的时候会刷新数据了
//                                                              [self_weak_ getNetData];
                                                          }else{
                                                              [self_weak_.view hiddenActivityWithTitle:@"购买失败"];
                                                          }
                                                      }];
                          }];
}

#pragma mark == webView  and UIWebViewDelegate
-(LQPlanWebFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[LQPlanWebFooterView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, CGFLOAT_MAX)];
        @weakify(self)
        _footerView.updataHeight = ^(CGFloat height) {
            [self_weak_.view hiddenActivity];
            [self_weak_.mainTableV reloadData];
            self_weak_.mainTableV.hidden = NO;
        };
    }
    return _footerView;
}

#pragma mark ==== timerView
-(LQRecommendTimerView *)timerView
{
    if (!_timerView) {
        _timerView = [[LQRecommendTimerView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 224+kLQSafeBottomHeight)];
    }
    return _timerView;
}

-(void)reloadTimerView
{
    NSDate *endDate = [self.detailObj.saleEndTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval endTimeInterval = endDate.timeIntervalSince1970 - NSDate.date.timeIntervalSince1970;
    [self.timerView updateTimeInterval:endTimeInterval];
}


@end
