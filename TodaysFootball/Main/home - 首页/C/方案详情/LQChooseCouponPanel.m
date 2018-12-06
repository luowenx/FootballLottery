//
//  LQChooseCouponPanel.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQChooseCouponPanel.h"
#import "LQChooseCouponCell.h"
#import "LQAvailableCoupon.h"

@interface LQChooseCouponPanel ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) LQAvailableCoupon * noneUseCoupon;

@end

@implementation LQChooseCouponPanel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.selectedIndex>[self tableView:self.tableView numberOfRowsInSection:0]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];

}

-(void)initUI
{
    UIButton *closeBtn = [UIButton newAutoLayoutView];
    [self.view addSubview:closeBtn];
    [closeBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIView *contentView = [UIView newAutoLayoutView];
    contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:contentView];
    [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [contentView autoSetDimension:ALDimensionHeight toSize:370 + kLQSafeBottomHeight];
    
    UILabel *canUserTips = [UILabel newAutoLayoutView];
    canUserTips.text = @"可用优惠券";
    canUserTips.textColor = UIColorFromRGB(0x404040);
    canUserTips.font = [UIFont lqsFontOfSize:30];
    [contentView addSubview:canUserTips];
    [canUserTips autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [canUserTips autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [contentView addSubview:_tableView];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:41];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:70 + kLQSafeBottomHeight];
    
    UIButton *suerBtn = [UIButton newAutoLayoutView];
    suerBtn.backgroundColor = [UIColor flsMainColor];
    [suerBtn roundedRectWith:4];
    [suerBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    suerBtn.titleLabel.font = [UIFont lqsFontOfSize:28];
    [suerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [suerBtn addTarget:self action:@selector(suerAction) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:suerBtn];
    [suerBtn autoSetDimensionsToSize:CGSizeMake(125, 35)];
    [suerBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [suerBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15 + kLQSafeBottomHeight];
    
    @weakify(self)
    [[closeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_ dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LQChooseCouponCellid";
    LQChooseCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LQChooseCouponCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    LQAvailableCoupon *coupon = [self.couponList safeObjectAtIndex:indexPath.row];
    cell.selectedImageView.hidden = (_selectedIndex != indexPath.row);

    if (!coupon.used) {
        cell.beanTips.text = nil;
        cell.conditionPriceTips.text = nil;
        cell.conditionRoleTips.text = nil;
        cell.conditionDateTips.text = nil;
        cell.noUserLabel.hidden = NO;
        return cell;
    }
    
    cell.noUserLabel.hidden = YES;
    switch (coupon.typeId) {
        case kLQCouponTypeDiscount:{
            cell.beanNumLabel.text = coupon.discount;
            cell.beanTips.text = @"折";
            break;
        }
        case kLQCouponTypeFullSale:{
            cell.beanNumLabel.text = @(coupon.amount).stringValue;
            cell.beanTips.text = @"乐豆";
            break;
        }
        case kLQCouponTypeDirectSale:{
            cell.beanNumLabel.text = @(coupon.amount).stringValue;
            cell.beanTips.text = @"乐豆";
            break;
        }
        default:
            break;
    }
    
    cell.conditionPriceTips.text = coupon.couponDesc;
    cell.conditionRoleTips.text = coupon.typeDesc;
    cell.conditionDateTips.text = coupon.expirationDate;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [self.tableView reloadData];
}


-(void)suerAction
{
    if (self.couponList.count == 0) {
        return;
    }
    
    LQAvailableCoupon *coupon = [self.couponList safeObjectAtIndex:_selectedIndex];
    if (self.chooseCouoon) {
        self.chooseCouoon(coupon);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark === getter  and setter

-(void)setCouponList:(NSArray *)couponList
{
    if (couponList == nil) {
        return;
    }
    
    if (![couponList containsObject:self.noneUseCoupon]) {
        NSMutableArray *arr = couponList.mutableCopy;
        [arr addObject:self.noneUseCoupon];
        couponList = arr.copy;
    }
    _couponList = couponList;
    [self.tableView reloadData];
}

-(LQAvailableCoupon *)noneUseCoupon
{
    if (!_noneUseCoupon) {
        _noneUseCoupon = [[LQAvailableCoupon alloc] init];
        _noneUseCoupon.used = NO;
    }
    return _noneUseCoupon;
}

@end
