//
//  LQOrderVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQOrderVC.h"
#import "LQProgrammeDetailsVC.h"
#import "LQPersonVC.h"

#import "LQBeanView.h"
#import "LQCollectionCell.h"
#import "LQMatchShowView2.h"

#import "LQMyOrdersReq.h"

#import "ExpertObj.h"
#import "LQMatchObj.h"
#import "LQExpertDetail.h"
#import "LQMyOrderPlanObj.h"


@interface LQOrderVC ()<UINavigationControllerDelegate>
@property (nonatomic) BOOL isNoReachable;

@end

@implementation LQOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self getDateisRefresh:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)initUI
{
    self.title = @"我的订单";
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

-(void)getDateisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.dataList.count;
    NSInteger limit = 10;
    LQMyOrdersReq *req = [[LQMyOrdersReq alloc] init];
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
        [self.dataList addObjectsFromArray:[LQMyOrderPlanObj objArrayWithDics:res.data]];
        
        [self.tableView reloadData];
        
        if (self.dataList.count<=0) {
            [self showEmptyViewImageName:@"empty_3" title:@"暂未购买任何文章，去看看吧"];
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
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark  =====  列表代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQCollectionCellID"];
    if (!cell) {
        cell = [[LQCollectionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQCollectionCellID"];
    }
    @weakify(self)
    cell.lookExpert = ^(LQMyOrderPlanObj* dataObj) {
        LQPersonVC *vc = [[LQPersonVC alloc] init];
        vc.userID = @(dataObj.expert.userId);
        vc.expertDetail = [[LQExpertDetail alloc] initWith:dataObj.expert.toJSON];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    
    LQMyOrderPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    cell.dataObj = planObj;
    [cell.avatarView.avatarImageView sd_setImageWithURL:[NSURL  URLWithString:planObj.expert.avatar] placeholderImage:LQPlaceholderIcon];
    cell.nameLable.text = stringNotNil(planObj.expert.nickname);
    cell.sloganLabel.text = stringNotNil(planObj.expert.slogan);
    cell.titleLabel.text = planObj.title;
    cell.matchView.matchLabel.text = planObj.earliestMatch.leagueName;
    cell.matchView.ranksLeftLabel.text = planObj.earliestMatch.homeName;
    cell.matchView.ranksRightLabel.text = planObj.earliestMatch.guestName;
    cell.matchView.scoreLabel.text = [NSString stringFormatIntervalSince1970_MonthDay_Slash:planObj.earliestMatch.matchTime ];
    cell.publishTimeLabel.text = [NSString stringFormatIntervalSince1970_MonthDayHourMinute_Slash:planObj.publishTime];

    cell.matchView.VSLabel.text = @"VS";
    cell.payTimeLabel.text = [[NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:planObj.purchasedTime] stringByAppendingString:@"  购买"];
    cell.collectionLabel.hidden = YES;
    cell.beanView.beanImageView.image = imageWithName(@"彩豆灰色");
    cell.beanView.beanLabel.textColor = UIColorFromRGB(0xa2a2a2);
    cell.beanView.beanLabel.text = [NSString stringWithFormat:@"%@乐豆", @(planObj.amount)];
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
            cell.hitRollLabel.hidden = !planObj.isWin;
            cell.hitRollBtn.hidden = NO;
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
    LQMyOrderPlanObj *planObj = [self.dataList safeObjectAtIndex:indexPath.row];
    LQProgrammeDetailsVC *vc = [[LQProgrammeDetailsVC alloc] init];
    vc.proID = @(planObj.threadId);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
