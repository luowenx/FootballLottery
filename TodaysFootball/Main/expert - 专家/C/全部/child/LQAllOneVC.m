//
//  LQAllOneVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAllOneVC.h"
#import "LQAllTableViewCell.h"
#import "LQPersonVC.h"
#import "LQLoginMainViewCtrl.h"

#import "LQExpertDetail.h"

#import "LQAllExpertReq.h"
#import "LQOptionManager.h"

@interface LQAllOneVC ()
@end

@implementation LQAllOneVC
{
    BOOL isLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self getDataisRefresh:YES];
    isLogin = userManager.isLogin;
    
    [self initObserver];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLogin != userManager.isLogin) {
        [self.tableView.mj_header beginRefreshing];
    }
    isLogin = userManager.isLogin;
}

-(void)initObserver
{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLQFollowExpertNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notifi) {
        if (self_weak_.viewAppear) {
            return;
        }
        
        NSDictionary *userInfo = notifi.userInfo;
        NSString *expertId = userInfo[kLQExpertIDKey];
        if (expertId.length <= 0) {
            return ;
        }
        
        for (LQExpertDetail *expert in self_weak_.dataList) {
            if ([@(expert.userId).stringValue isEqualToString:expertId]) {
                expert.hasFollowed = [userInfo[kLQExpertFollowedKey] boolValue];
                [self_weak_.tableView reloadData];
                break;
            }
        }
    }];
}

- (void)initUI
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
}

#pragma mark ===  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allcell"];
    if (!cell) {
        cell = [[LQAllTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"allcell"];
    }
    LQExpertDetail *expertDetail = [self.dataList safeObjectAtIndex:indexPath.row];
    [cell.avatarImageView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:expertDetail.avatar] placeholderImage:LQPlaceholderIcon];
    cell.nameLabel.text = stringNotNil(expertDetail.nickname);
    cell.sloganLabel.text = stringNotNil(expertDetail.slogan);
    cell.subTitleLine.hidden = cell.sloganLabel.text.length == 0;
    cell.sloganIsWelt = cell.sloganLabel.text.length == 0;
    cell.hitRollLabel.text = [NSString stringWithFormat:@"%@%@命中率",  @((int)round(expertDetail.hitRate * 100)), @"%"];
    [cell.followButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    [cell.followButton setTitle:@"已关注" forState:(UIControlStateSelected)];
    cell.followButton.selected = expertDetail.hasFollowed;
    [cell.followButton setBackgroundColor:expertDetail.hasFollowed ? UIColorFromRGB(0xa3a3a3): [UIColor flsMainColor]];
    
    @weakify(self)
    cell.follow = ^(LQExpertDetail *dataObj, UIButton *sender) {
        if (!userManager.isLogin) {
            LQLoginMainViewCtrl *logViewCtrl = [[LQLoginMainViewCtrl alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewCtrl];
            [self_weak_ presentViewController:nav animated:YES completion:^{}];
            return ;
        }
        
        [self_weak_.view showActivityViewWithTitle:nil];
        [LQOptionManager followExpertCurrentisFollowed:sender.isSelected
                                          expertUserId:@(dataObj.userId).stringValue
                                              callBack:^(BOOL success, NSError *error) {
                                                  if (success) {
                                                      sender.selected = !sender.isSelected;
                                                      dataObj.hasFollowed = sender.isSelected;
                                                      [sender setBackgroundColor:dataObj.hasFollowed ? UIColorFromRGB(0xa3a3a3): [UIColor flsMainColor]];
                                                      [self_weak_.view hiddenActivityWithTitle:@"操作成功"];
                                                  }else{
                                                      [self_weak_.view hiddenActivityWithTitle:@"操作失败"];
                                                  }
                                              }];
    };
    cell.dataObj = expertDetail;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LQExpertDetail *expertDetail = [self.dataList safeObjectAtIndex:indexPath.row];
    LQPersonVC *vc = [[LQPersonVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userID = @(expertDetail.userId);
    vc.expertDetail = expertDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

#pragma mark  === 获取数据

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger offset = isRefresh?0:self.dataList.count;
    NSInteger limit = 10;
    
    LQAllExpertReq *req = [[LQAllExpertReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        LQAllExpertRes * res = (LQAllExpertRes* )response;
        if (res.ret == 0) {
            if (isRefresh) {
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:[LQExpertDetail objArrayWithDics:res.expers].copy];
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.dataList addObjectsFromArray:[LQExpertDetail objArrayWithDics:res.expers].copy];
            }
        }
        
        [self.tableView reloadData];
    } error:^(NSError *error) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self showError:error];
        if (error.code == kLQNetErrorCodeNotReachable) {
            self.tableView.mj_footer.hidden = YES;
        }
    }];
}

@end
