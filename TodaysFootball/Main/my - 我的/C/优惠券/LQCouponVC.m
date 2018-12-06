//
//  LQCouponVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/24.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQCouponVC.h"

#import "MCSPageingView.h"
#import "LQCouponCell.h"

#import "LQCouponViewModel.h"


@interface LQCouponVC ()
@property (nonatomic, strong) MCSPageingView * pageView;

@property (nonatomic, strong) LQCouponViewModel * viewModel;

@end

@implementation LQCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initViewModel];
}

-(void)initTableConstraints
{
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kMCSPageingViewSizeHeight];
}

-(void)initUI
{
    self.title = @"优惠券";
    @weakify(self)
    self.pageView = [[MCSPageingView alloc] initWithTitles:@[@"未使用", @"已使用", @"已过期"]
                                               selectBlock:^BOOL(MCSPageingView *pageingView, NSUInteger index) {
                                                   @strongify(self)
                                                   self.viewModel.type = (index+1);
                                                   [self.tableView reloadData];
                                                   [self pullData];
                                                   return YES;
    }];
    
    [self.view addSubview:self.pageView];
    [self.pageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.pageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.pageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
}

-(void)initViewModel
{
    self.viewModel = [[LQCouponViewModel alloc] init];
    self.viewModel.type = kLQCouponTypeOwned;
    [self pullData];
}

-(void)pullData
{
    @weakify(self)
    [self.viewModel pullDataWithCallBack:^(BOOL success, NSError *error) {
        if (success) {
            [self_weak_.tableView reloadData];
        }
        
        if (self_weak_.dataList.count>0) {
            return;
        }
        if (error.code == kLQNetErrorCodeNotReachable) {
            [self_weak_.tableView reloadData];
        }
    }];
}

-(void)reloadEmptyView
{
    [super reloadEmptyView];
    [self pullData];
}

#pragma mark === UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.viewModel.dataList.count);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.viewModel.dataList.count <= 0){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self showEmptyViewInView:cell.contentView imageName:self.viewModel.emptyImageName title:self.viewModel.emptyString];
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        cell.contentView.userInteractionEnabled = self.viewModel.emptyUserInteractionEnabled;
        return cell;
    }
    static NSString *cellID = @"LQCouponCell";
    LQCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LQCouponCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    LQCouponObj *obj = [self.viewModel.dataList safeObjectAtIndex:indexPath.row];
    
    cell.beanNumLabel.text = @(obj.amount).stringValue;
    cell.conditionPriceTips.text = obj.couponDesc;
    cell.conditionRoleTips.text = obj.packageName;
    cell.conditionDateTips.text = [NSString stringWithFormat:@"%@到期", obj.expirationDate];
//    cell.bottomTips.text = @"仅适用于新用户";
    if (self.viewModel.type == kLQCouponTypeOwned) {
        cell.bgView.image = imageWithName(@"mine_优惠券_bg");
        cell.beanNumLabel.textColor = [UIColor flsMainColor];
    }else{
        cell.bgView.image = imageWithName(@"coupon_gray");
        cell.beanNumLabel.textColor = UIColorFromRGB(0x404040);
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.viewModel.dataList.count <= 0) return self.tableView.frame.size.height;
    return 120;
}

@end

