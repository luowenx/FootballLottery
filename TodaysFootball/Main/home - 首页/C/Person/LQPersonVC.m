//
//  LQPersonVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPersonVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQLoginMainViewCtrl.h"
#import "LQExpertDesLinkViewCtrl.h"

#import "LQPersonTableViewCell.h"
#import "LQPerMatchTableViewCell.h"
#import "LQMatchTagView.h"

#import "LQExpertsReq.h"
#import "LQOptionManager.h"

#import "LQPersonPlanObj.h"
#import "LQExpertDetail.h"
#import "LQMatchObj.h"

#import <UShareUI/UShareUI.h>

@interface LQPersonVC ()
@property (nonatomic, strong) UIView *navView;

@property (nonatomic, copy) NSString * titleStr;

@end

@implementation LQPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatUI];
    [self getDataisRefresh:YES];
    
    @weakify(self)
    [[RACObserve(userManager, currentUser) skip:1] subscribeNext:^(id x) {
        [self_weak_ getDataisRefresh:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initTableConstraints
{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)creatUI{
    //自定义导航栏
//    self.tableView.bounces = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, kLQNavANDStatusBarHeight)];
    self.navView.backgroundColor = [UIColor flsMainColor];
    self.navView.alpha = 0;
    [self.view addSubview:self.navView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kLQStatusBarHeight, UIDeviceScreenWidth, kLQNavHeight)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    @weakify(self)
    UIButton *backBtn = [UIButton newAutoLayoutView];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    [backBtn setImage:imageWithName(@"return") forState:(UIControlStateNormal)];
    [self.navView addSubview:backBtn];
    [backBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [backBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    
    UIButton *shareBtn = [UIButton newAutoLayoutView];
    [shareBtn setImage:imageWithName(@"share") forState:(UIControlStateNormal)];
    [self.navView addSubview:shareBtn];
    [shareBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    
    UIButton *followBtn = [UIButton newAutoLayoutView];
    [followBtn setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    [followBtn setTitle:@"已关注" forState:(UIControlStateSelected)];
    [followBtn setCornerRadius:3 borderColor:[UIColor whiteColor] borderWidth:1];
    followBtn.titleLabel.font = [UIFont lqsFontOfSize:28];
    [self.navView addSubview:followBtn];
    [followBtn autoSetDimensionsToSize:CGSizeMake(64, 27)];
    [followBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
    [followBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shareBtn withOffset:-10];
    
    [RACObserve(self, expertDetail.hasFollowed) subscribeNext:^(id x) {
        if (self_weak_.expertDetail) {
            followBtn.selected = self_weak_.expertDetail.hasFollowed;
        }
    }];
    RAC(titleLabel, text) =  RACObserve(self, expertDetail.nickname);
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    
    // 关注
    [followBtn addTarget:self action:@selector(followExpert:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 分享
    [[shareBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_ shareExpert];
    }];
    
    [[backBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_ onBack];
    }];
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.dataList.count;
    NSInteger limit = isRefresh?5:10;
    LQExpertsReq *req = [[LQExpertsReq alloc] init];
    req.isNeedCache = isRefresh;
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@/%@", self.userID, @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        [self.tableView.mj_footer endRefreshing];
        LQExpertsRes *res = (LQExpertsRes *)response;
        if (res.expertDetail) {
            self.expertDetail = [[LQExpertDetail alloc] initWith:res.expertDetail];
        }
        
        NSArray *datalist = [LQPersonPlanObj objArrayWithDics:(NSArray<NSDictionary *> *)res.expertPlanList];
        
        if (isRefresh) {
            self.navView.alpha = 0;
            self.tableView.mj_footer.hidden = NO;
            [self.dataList removeAllObjects];
        }
        if (datalist.count>0) {
            [self.dataList addObjectsFromArray:datalist];
            [self.tableView reloadData];
        }
        
    } error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        if (self.dataList.count > 0 || self.expertDetail) {
            return;
        }
        if (error.code == kLQNetErrorCodeNotReachable) {
            UIView *emptyView = [self showEmptyViewInView:self.view imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
            [emptyView removeFromSuperview];
            [self.view insertSubview:emptyView belowSubview:self.navView];
            [emptyView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            self.tableView.mj_footer.hidden = YES;
            self.navView.alpha = 1;
        }
    }];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    [self getDataisRefresh:YES];
}

#pragma mark ==== UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count + (self.expertDetail?1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        LQPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personcell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQPersonTableViewCell" owner:self options:nil] lastObject];
        }
        @weakify(self)
        cell.personCellAction = ^(PersonCellActionType type) {
            [self_weak_ detailAction:type];
        };
        
        cell.follow = ^(UIButton *sender) {
            [self_weak_ followExpert:sender];
        };
        
        cell.descLink = ^(LQExpertDetail * dataObj) {
            LQExpertDesLinkViewCtrl *webVC = [[LQExpertDesLinkViewCtrl alloc] init];
            webVC.requestURL = dataObj.descLink;
            [self_weak_.navigationController pushViewController:webVC animated:YES];
        };
        
        LQExpertDetail *expertDetail = self.expertDetail;
        cell.dataObj = expertDetail;
        cell.redView.alpha = 1;
        [cell.headIma sd_setImageWithURL:[NSURL URLWithString:expertDetail.avatar] placeholderImage:LQPlaceholderIcon];
        cell.nameL.text = expertDetail.nickname;
        cell.PosPerL.text = expertDetail.slogan;
        cell.fansL.text = [NSString stringWithFormat:@"粉丝 %@",@(expertDetail.follower)];
        cell.hitNowL.text = @(expertDetail.conWin).stringValue;
        cell.hitDelNowL.text = [NSString stringWithFormat:@"最高%@连红", @(expertDetail.maxWin)];
        cell.hitDeL.text = expertDetail.bAllRate;
        cell.hitL.text = @((int)round(expertDetail.hitRate * 100)).stringValue;
        
        if (expertDetail.aDescription.length>0 && expertDetail.descLink.length > 0) {
            NSString *briefStr = [expertDetail.aDescription stringByAppendingString:@" 详情>"] ;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 6;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont lqsFontOfSize:24],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:briefStr attributes:attributes];
            [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa2a2a2) range:NSMakeRange(0, expertDetail.aDescription.length)];
            [attrStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:expertDetail.descLink] range:[briefStr rangeOfString:@" 详情>"]];

            cell.briefTextView.attributedText = attrStr;
            cell.desL.text = expertDetail.aDescription;
            cell.desL.hidden = YES;
        }else{
            cell.desL.text = expertDetail.aDescription;
            cell.desL.hidden = NO;
            cell.briefTextView.hidden = YES;
        }
        
        cell.followBtn.selected = expertDetail.hasFollowed;
        return cell;
    }else{
        LQPerMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personmatchcell"];
        if (!cell) {
            cell = [[LQPerMatchTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"personmatchcell"];
        }
        LQPersonPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row -1];
        cell.titleLabel.text = planObj.title;
        cell.matchLabel.text = planObj.earliestMatch.leagueName;
        cell.ranksLeftLabel.text = planObj.earliestMatch.homeName;
        cell.ranksRightLabel.text = planObj.earliestMatch.guestName;
        cell.timeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:planObj.publishTime];
        cell.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:planObj.earliestMatch.matchTime];
        cell.VSLabel.text = @"VS";
        cell.lookNumbersLabel.text = [NSString stringWithFormat:@"已查看%@次", @(planObj.views)];

        [cell.ingButton setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];
        cell.ingButton.hidden = YES;
        cell.hitTitleLabel.hidden = YES;
        cell.hitImageView.hidden = YES;
        cell.lookNumbersLabel.hidden = YES;
        switch (planObj.plock) {
            case kLQThreadPlockCanPurchase:{  // 未开始
                cell.lookNumbersLabel.hidden = NO;
                break;
            }
            case kLQThreadPlockUnderway:{  // 进行中
                cell.ingButton.hidden = NO;
                [cell.ingButton setTitle:@"进行中" forState:(UIControlStateNormal)];
                break;
            }
            case kLQThreadPlockFinished:{  // 已结束
                cell.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(planObj.earliestMatch.homeScore), @(planObj.earliestMatch.guestScore)];
                cell.hitImageView.hidden = NO;
                if (planObj.isWin) {
                    if (planObj.hitRateValue.length>0) {
                        NSArray *hitRtes = [planObj.hitRateValue componentsSeparatedByString:@"/"];
                        hitRtes = [[hitRtes reverseObjectEnumerator] allObjects];
                        cell.hitTitleLabel.text = [hitRtes componentsJoinedByString:@"中"];
                    }
                    cell.hitTitleLabel.hidden = NO;
                    cell.hitImageView.selected = NO;
                }else{
                    cell.hitImageView.selected = YES;
                }
                break;
            }
            case kLQThreadPlockCancel:{ // 已取消
                cell.ingButton.hidden = NO;
                [cell.ingButton setTitle:@"已取消" forState:(UIControlStateNormal)];
                [cell.ingButton setTitleColor:[UIColor flsCancelColor] forState:(UIControlStateNormal)];

                break;
            }
            default:
                break;
        }
        
        if ((planObj.plock < kLQThreadPlockFinished) && (!planObj.purchased)&&(planObj.price)) { // 未购买并且价格不为0
            cell.beanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(planObj.price)];
            cell.beanView.hidden = NO;
            cell.lookButton.hidden = YES;
        }else{// 显示查看
            cell.beanView.hidden = YES;
            cell.lookButton.hidden = NO;
        }
        
        cell.dataObj = planObj;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat cellHeight = 260;
        NSString *briefStr = self.expertDetail.aDescription;
        if (self.expertDetail.aDescription.length > 0 && self.expertDetail.descLink.length > 0) {
            briefStr = [self.expertDetail.aDescription stringByAppendingString:@" 详情>"] ;
        }
        cellHeight += [briefStr sizeWithFont:[UIFont lqsFontOfSize:24] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
        return cellHeight;
    }
    
    LQPersonPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row -1];

    if (planObj.cacheHeight <= CGFLOAT_MIN) {
        planObj.cacheHeight = [LQPerMatchTableViewCell staticHeight];
        planObj.cacheHeight += [planObj.title sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
    }
    
    return planObj.cacheHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    LQPersonPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row -1];
    LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
    vc.proID = @(planObj.threadId);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)detailAction:(PersonCellActionType)type
{
    switch (type) {
        case kPersonCellActionBack:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case kPersonCellActionShare:{
            [self shareExpert];
            break;
        }
        default:
            break;
    }
}

-(void)shareExpert
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
        NSString *title = [NSString stringWithFormat:@"%@，%@", self.expertDetail.nickname, self.expertDetail.slogan];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                                 descr:self.expertDetail.aDescription
                                                                             thumImage:self.expertDetail.avatar];
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@/expert/%@%@", LQWebURL, self.userID, LQWebPramSuffix];
        messageObj.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObj
                                    currentViewController:self
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
}

-(void)followExpert:(UIButton *)sender
{
    if (!userManager.isLogin) {
        [self gotoLogin];return;
    }
    [self.view showActivityViewWithTitle:nil];
    [LQOptionManager followExpertCurrentisFollowed:sender.isSelected
                                      expertUserId:@(self.expertDetail.userId).stringValue
                                          callBack:^(BOOL success, NSError *error) {
                                              if (success) {
                                                  sender.selected = !sender.isSelected;
                                                  self.expertDetail.hasFollowed =  sender.selected;
                                                  self.expertDetail.follower += sender.selected?1:-1;
                                                  [self.view hiddenActivityWithTitle:@"操作成功"];
                                                  [self.tableView reloadData];
                                              }else{
                                                  [self.view hiddenActivityWithTitle:@"操作失败"];
                                              }
                                          }];
}

-(void)gotoLogin
{
    LQLoginMainViewCtrl *logViewCtrl = [[LQLoginMainViewCtrl alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewCtrl];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    if(offset_Y <= 0){
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    CGFloat alpha = (offset_Y)/100.0f;
    alpha = MAX(0, MIN(1, alpha));
    CGFloat alphaView = 1-alpha;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    LQPersonTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];

    self.navView.alpha = alpha;
    cell.redView.alpha = alphaView;
}
@end

