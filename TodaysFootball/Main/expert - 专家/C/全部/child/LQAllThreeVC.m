//
//  LQAllThreeVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAllThreeVC.h"
#import "LQPersonVC.h"

#import "LQWeekProTableViewCell.h"

#import "LQExpertPopularityReq.h"

#import "LQRankExpertObj.h"
#import "LQExpertDetail.h"

@interface LQAllThreeVC ()
@end

@implementation LQAllThreeVC
{
    BOOL isLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    [self initUI];
    isLogin = userManager.isLogin;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLogin != userManager.isLogin) {
        [self.tableView.mj_header beginRefreshing];
    }
    isLogin = userManager.isLogin;
}

- (void)initUI
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LQWeekProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weekcell2"];
    if (!cell) {
        cell = [[LQWeekProTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"weekcell2"];
    }
    LQRankExpertObj *expertObj = [self.dataList safeObjectAtIndex:indexPath.row];
    [cell.avatarImageView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:expertObj.avatar] placeholderImage:LQPlaceholderIcon];
    cell.nameLabel.text = stringNotNil(expertObj.nickname);
    cell.sloganLabel.text = [expertObj.slogan stringByAppendingString:stringNotNil(expertObj.threadCount)];
    cell.extensionLabel.text = @(expertObj.popularity).stringValue;
    cell.extensionIImageView.hidden  = YES;
    cell.followButton.hidden = YES;
    
    cell.rank = indexPath.row + 1;
    
    cell.dataObj = expertObj;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LQRankExpertObj *expertObj = self.dataList[indexPath.row];
    LQPersonVC *vc = [[LQPersonVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userID = @(expertObj.userId);
    vc.expertDetail = [[LQExpertDetail alloc] initWith:expertObj.toJSON];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

#pragma mark == 数据拉取
- (void)getData
{
    LQExpertPopularityReq *req = [[LQExpertPopularityReq alloc] init];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:[LQRankExpertObj objArrayWithDics:res.data].copy];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showError:error];
    }];
}


@end

