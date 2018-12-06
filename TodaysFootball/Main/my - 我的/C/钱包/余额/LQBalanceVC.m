//
//  LQBalanceVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBalanceVC.h"
#import "LQRechargeVC.h"

#import "LQBeanView.h"
#import "LQBalanceTableViewCell.h"

#import "LQExpenseListReq.h"

#import "LQPurchaseRecord.h"

@interface LQBalanceVC ()

@property (nonatomic, strong) LQBeanView * beanView;

@end

@implementation LQBalanceVC{
    UIView *empyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self getDataisRefresh:YES];
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.dataList.count;
    NSInteger limit = 10;
    LQExpenseListReq *req = [[LQExpenseListReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        LQExpenseListRes *res = (LQExpenseListRes *)response;
        if(isRefresh){
            [self.dataList removeAllObjects];
        }
        if(res.ret == kLQNetResponseSuccess){
            if (isRefresh) {
                userManager.currentUser.colorbean = res.colorbean;
                [userManager saveCurrentUser];
            }
            [self.dataList addObjectsFromArray:[LQPurchaseRecord objArrayWithDics:res.expenseList]];
            [self.tableView reloadData];
        }
        if(isRefresh){
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = self.dataList.count <= 0;
            if(self.dataList.count <= 0){
                [self showEmptyViewInView:empyView imageName:@"empty_2" title:@"您还没有充值消费记录"];
                empyView.hidden = NO;
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.dataList.count>0) {
            return;
        }
        if (error.code == kLQNetErrorCodeNotReachable) {
            [self showEmptyViewInView:empyView imageName:@"notNetReachable" title:@"点击屏幕重新加载"];
            empyView.hidden = NO;
            self.tableView.mj_footer.hidden = YES;
        }
    }];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    empyView.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)initTableConstraints
{
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:68];
}

-(void)initUI
{
    self.title = @"余额";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
     [self.tableView registerNib:[UINib nibWithNibName:@"LQBalanceTableViewCell"  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"balancecell"];
    
    UIView *balanceView = [UIView newAutoLayoutView];
    balanceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:balanceView];
    [balanceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [balanceView autoSetDimension:ALDimensionHeight toSize:52];
    
    UILabel *balanceLabel = [UILabel newAutoLayoutView];
    balanceLabel.textColor = UIColorFromRGB(0x404040);
    balanceLabel.font = [UIFont lqsFontOfSize:30 isBold:YES];
    balanceLabel.text = @"余额";
    [balanceView addSubview:balanceLabel];
    [balanceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [balanceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    
    self.beanView = [LQBeanView newAutoLayoutView];
    [balanceView addSubview:self.beanView];
    [self.beanView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.beanView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:balanceLabel withOffset:10];
    
    UIButton *rechargeBtn = [UIButton newAutoLayoutView];
    [rechargeBtn setBackgroundColor:[UIColor flsMainColor]];
    [rechargeBtn roundedRectWith:4];
    rechargeBtn.titleLabel.font = [UIFont lqsFontOfSize:30];
    UIImage *rechargeImag = imageWithName(@"充值箭头");
    [rechargeBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    [rechargeBtn setImage:rechargeImag forState:(UIControlStateNormal)];
    [rechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -rechargeImag.size.width, 0, rechargeImag.size.width)];
    [rechargeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, rechargeBtn.titleLabel.font.pointSize*2 + 12, 0, - rechargeBtn.titleLabel.font.pointSize*2)];
    [balanceView addSubview:rechargeBtn];
    [rechargeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [rechargeBtn autoSetDimensionsToSize:CGSizeMake(72, 25)];
    [rechargeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
    
    @weakify(self)
    [RACObserve(userManager, currentUser.colorbean) subscribeNext:^(id x) {
        NSString *str = [NSString stringWithFormat:@"%@ 乐豆",@([x integerValue])];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont lqsFontOfSize:30 isBold:YES] range:NSMakeRange(0, str.length-2)];
        self_weak_.beanView.beanLabel.attributedText = attriStr;
    }];
    
    [[rechargeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        LQRechargeVC *recargeVC = [[LQRechargeVC alloc] init];
        [self_weak_.navigationController pushViewController:recargeVC animated:YES];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    
    empyView = [UIView newAutoLayoutView];
    empyView.hidden = YES;
    [self.view addSubview:empyView];
    [empyView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [empyView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:68];
}

#pragma mark   = =  UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balancecell"];
    LQPurchaseRecord *recordObj = [self.dataList safeObjectAtIndex:indexPath.row];
    if(recordObj.type == kPurchaseLQRecordConsume){
        cell.headIma.image = imageWithName(@"购物");
        cell.priceLabel.text = [@"-" stringByAppendingString:@(recordObj.amount).stringValue];
        cell.typeLabel.text = @"购";
        cell.typeLabel.textColor = cell.titleL.textColor;

    }else if (recordObj.type == kLQRechargeRecordRecharge){
        cell.headIma.image = imageWithName(@"充值");
        cell.priceLabel.text = [@"+" stringByAppendingString:@(recordObj.amount).stringValue];
        cell.typeLabel.text = @"充";
        cell.typeLabel.textColor = [UIColor whiteColor];

    }
    cell.titleL.text = recordObj.remark;
    cell.timeL.text = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:recordObj.expenseTime];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

@end
