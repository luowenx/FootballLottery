//
//  LQSelectorViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQSelectorViewCtrl.h"
#import "LQSelectorItemCell.h"

@interface LQSelectorViewCtrl ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * selectorTableView;

@end

@implementation LQSelectorViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _selectorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self.view addSubview:_selectorTableView];
    _selectorTableView.delegate = self;
    _selectorTableView.dataSource = self;
    _selectorTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (@available(iOS 11.0, *)) {
        _selectorTableView.estimatedRowHeight = 0;
        _selectorTableView.estimatedSectionFooterHeight = 0;
        _selectorTableView.estimatedSectionHeaderHeight = 0;
        _selectorTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_selectorTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_selectorTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_selectorTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_selectorTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

#pragma mark  ==  UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LQSelectorItemCellid";
    LQSelectorItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LQSelectorItemCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.identificationView.image = imageWithName(@"gener");
    cell.identificationView.hidden = !(indexPath.row == self.selectedIndex);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selecting) {
        self.selecting(indexPath.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
