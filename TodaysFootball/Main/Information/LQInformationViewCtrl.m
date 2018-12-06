//
//  LQInformationViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInformationViewCtrl.h"
#import "LQDetailInfomationViewCtrl.h"

#import "LQInfomationCell.h"

#import "LQInformationListReq.h"

#import "LQInformation.h"

@interface LQInformationViewCtrl ()

@end

@implementation LQInformationViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



- (void)initUI
{
    [self addLeftNavWithImageName:nil hander:nil];
    self.title = @"资讯";

    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"无更多资讯" forState:(MJRefreshStateNoMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger limit = 10;
    NSInteger offset = isRefresh? 0 : self.dataList.count;
    LQInformationListReq *req = [[LQInformationListReq alloc] init];
    [req apendRelativeUrlWith:[NSString stringWithFormat:@"/%@/%@", @(offset), @(limit)]];
    [req requestWithCompletion:^(id response) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableView.mj_footer.hidden = NO;
        
        if (isRefresh) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.dataList removeAllObjects];
        }

        LQInformationListRes *res = (LQInformationListRes *)response;
        NSArray *datalist = [LQInformation objArrayWithDics:(NSArray<NSDictionary *> *)res.data];
        if (datalist.count > 0) {
            [self.dataList addObjectsFromArray:datalist];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    } error:^(id error) {
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableView.mj_footer.hidden = YES;
        [self showError:error];
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQInfomationCell"];
    if (!cell) {
        cell = [[LQInfomationCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQInfomationCell"];
    }
    
    LQInformation *info = [self.dataList safeObjectAtIndex:indexPath.row];
    
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:info.coverImg]
                           placeholderImage:LQPlaceholderInformationIcon];
    cell.titleLabel.text = info.title;
    cell.subTitleLabel.text = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:[info.publishTime doubleValue]];
    
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LQInfomationCell selfHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LQInformation *info = [self.dataList safeObjectAtIndex:indexPath.row];

    LQDetailInfomationViewCtrl *infomationViewCtrl = [[LQDetailInfomationViewCtrl alloc] init];
    infomationViewCtrl.requestURL = info.url;
    infomationViewCtrl.infoObj = info;
    infomationViewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infomationViewCtrl animated:YES];
}

@end
