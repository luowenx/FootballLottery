//
//  LQCollectionVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCollectionVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQPersonVC.h"

#import "LQBeanView.h"
#import "LQCollectionCell.h"
#import "LQMatchShowView2.h"

#import "LQMyCollectionReq.h"

#import "ExpertObj.h"
#import "LQMatchObj.h"
#import "LQExpertDetail.h"
#import "LQExpertPlanObj.h"
#import "LQOptionManager.h"

@interface LQCollectionVC ()
@property (nonatomic) BOOL isNoReachable;
@end

@implementation LQCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self getDateisRefresh:YES];
    [self initObserver];
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
        
        for (LQExpertPlanObj *planObj in self_weak_.dataList) {
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
    self.navigationController.navigationBar.hidden = NO;
}

-(void)getDateisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.dataList.count;
    NSInteger limit = 10;
    LQMyCollectionReq *req = [[LQMyCollectionReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (isRefresh) {
            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            [self.dataList removeAllObjects];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataList addObjectsFromArray:[LQExpertPlanObj objArrayWithDics:res.data]];

        [self.tableView reloadData];
        
        if (self.dataList.count <= 0) {
            [self showEmptyViewImageName:@"empty_1" title:@"暂未收藏任何文章，去看看吧"];
        }
        self.tableView.mj_footer.hidden = (self.dataList.count<=limit);
    } error:^(NSError *error) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self showError:error];
        if (error.code == kLQNetErrorCodeNotReachable) {
            self.tableView.mj_footer.hidden = YES;
            self.isNoReachable = YES;
        }
    }];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    if (self.isNoReachable) {
        [self.tableView.mj_header beginRefreshing];return;
    }
    [self.tabBarController setSelectedIndex:1];

    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)initUI
{
    self.title = @"我的收藏";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDateisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDateisRefresh:NO];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQCollectionCell"];
    if (!cell) {
        cell = [[LQCollectionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQCollectionCell"];
    }
    @weakify(self)
    cell.lookExpert = ^(LQExpertPlanObj* dataObj) {
        LQPersonVC *vc = [[LQPersonVC alloc] init];
        vc.userID = @(dataObj.expert.userId);
        vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.expert.toJSON];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    LQExpertPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    cell.dataObj = planObj;
    [cell.avatarView.avatarImageView sd_setImageWithURL:[NSURL  URLWithString:planObj.expert.avatar] placeholderImage:LQPlaceholderIcon];
    cell.nameLable.text = stringNotNil(planObj.expert.nickname);
    cell.sloganLabel.text = stringNotNil(planObj.expert.slogan);
    cell.titleLabel.text = planObj.title;
    cell.matchView.matchLabel.text = planObj.earliestMatch.leagueName;
    cell.matchView.ranksLeftLabel.text = planObj.earliestMatch.homeName;
    cell.matchView.ranksRightLabel.text = planObj.earliestMatch.guestName;
    cell.matchView.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:planObj.earliestMatch.matchTime];
    cell.publishTimeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:planObj.publishTime];
    
    cell.matchView.VSLabel.text = @"VS";
    cell.beanView.hidden = YES;

    NSString *favoriteTime = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:planObj.favoriteTime];
    cell.collectionLabel.text = [favoriteTime stringByAppendingString:@"  收藏"];
    cell.payTimeLabel.hidden = YES;
    cell.lookNumbersLabel.text = [NSString stringWithFormat:@"已查看%@次", @(planObj.views)];
    cell.priceBeanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(planObj.price)];

    if (planObj.hitRateValue.length>0 && planObj.isWin) {
        NSArray *hitRtes = [planObj.hitRateValue componentsSeparatedByString:@"/"];
        hitRtes = [[hitRtes reverseObjectEnumerator] allObjects];
        cell.hitRollLabel.text = [hitRtes componentsJoinedByString:@"中"];
    }

    BOOL showBean = (planObj.plock == kLQThreadPlockCanPurchase) && (!planObj.purchased)&&(planObj.price>0);
    cell.priceBeanView.hidden = !showBean;
    cell.lookLabel.hidden = showBean;
    
    cell.hitRollLabel.hidden = YES;
    cell.hitRollBtn.hidden = YES;
    cell.matchStatusLabel.hidden = YES;
    cell.lookNumbersLabel.hidden = YES;
    
    switch (planObj.plock) {
        case kLQThreadPlockCanPurchase:{ // 未开始
            cell.lookNumbersLabel.hidden = NO;
            break;
        }
        case kLQThreadPlockUnderway:{ // 进行中
            cell.matchStatusLabel.hidden = NO;
            cell.matchStatusLabel.text = @"进行中";
            cell.matchStatusLabel.textColor = [UIColor flsMainColor];
            break;
        }
        case kLQThreadPlockFinished:{ // 已结束
            cell.hitRollBtn.hidden = NO;
            cell.hitRollLabel.hidden = !planObj.isWin;
            cell.hitRollBtn.selected = !planObj.isWin;
            cell.matchView.VSLabel.text = [NSString stringWithFormat:@"%@ : %@", @(planObj.earliestMatch.homeScore), @(planObj.earliestMatch.guestScore)];
            break;
        }
        case kLQThreadPlockCancel:{ // 已取消
            cell.matchStatusLabel.hidden = NO;
            cell.matchStatusLabel.text = @"已取消";
            cell.matchStatusLabel.textColor = [UIColor flsCancelColor];
            break;
        }
        default:
            break;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQExpertPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    if (planObj.cacheHeight <= CGFLOAT_MIN) {
        planObj.cacheHeight = [LQCollectionCell staticHeight];
        planObj.cacheHeight += [planObj.title sizeWithFont:[UIFont lqsFontOfSize:32] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
    }
    return planObj.cacheHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQExpertPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
    vc.proID = @(planObj.threadId);
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消\n收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    LQExpertPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    
    @weakify(self)
    [self alertViewShowWithTitle:nil
                         message:@"取消收藏? "
                          cancel:@"否"
                           other:@"是"
                    clickedBlock:^(BOOL isTrue) {
                        if (!isTrue) {return;}
                        @strongify(self)
                        [self.view showActivityViewWithTitle:nil];
                        [LQOptionManager planisFavorite:YES
                                               threadId:@(planObj.threadId).stringValue
                                               callBack:^(BOOL success, NSError *error) {
                                                   if (success) {
                                                       [self.view hiddenActivityWithTitle:@"取消收藏成功"];
                                                       [self.tableView.mj_header beginRefreshing];
                                                   }else{
                                                       [self.view hiddenActivityWithTitle:@"取消收藏失败"];
                                                   }
                                               }];
                    }];
}


@end
