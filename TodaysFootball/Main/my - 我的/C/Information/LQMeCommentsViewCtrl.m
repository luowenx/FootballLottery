//
//  LQMeMeCommentsViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMeCommentsViewCtrl.h"
#import "LQDetailInfomationViewCtrl.h"

#import "LQMeCommsCell.h"

#import "LQMeCommsReq.h"
#import "LQDeleteCommReq.h"
#import "LQMeComment.h"

@interface LQMeCommentsViewCtrl ()

@end

@implementation LQMeCommentsViewCtrl

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
    self.title = @"我的评论";
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"无更多评论" forState:(MJRefreshStateNoMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger limit = 10;
    NSInteger offset = isRefresh? 0 : self.dataList.count;
    LQMeCommsReq *req = [[LQMeCommsReq alloc] init];
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
        
        LQNetResponse *res = (LQNetResponse *)response;
        NSArray *datalist = [LQMeComment objArrayWithDics:(NSArray<NSDictionary *> *)res.data];
        if (datalist.count > 0) {
            [self.dataList addObjectsFromArray:datalist];
        }
        [self.tableView reloadData];
        
        if (datalist.count < limit) {
            self.tableView.mj_footer.hidden = YES;
        }
        if (self.dataList.count <= 0) {
            UIView *empty = [self showEmptyViewImageName:@"empty_1" title:@"您还未评论过任何资讯"];
            empty.userInteractionEnabled = NO;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQMeCommsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQMeCommsCell"];
    if (!cell) {
        cell = [[LQMeCommsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQMeCommsCell"];
    }
    LQMeComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:userManager.currentUser.avatar]
                          placeholderImage:LQPlaceholderIcon];
    if ([userManager.currentUser.gender  isEqual: @"1"]) {
        cell.genderImageView.image = imageWithName(@"Profile_manIcon");
    }else{
        cell.genderImageView.image = imageWithName(@"Profile_womanIcon");
    }
    cell.timeLabel.text = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:[comm.commentTime doubleValue]];
    cell.nameLabel.text = stringNotNil(userManager.currentUser.nickName);
    cell.contentLabel.text = stringNotNil(comm.content);
    
    cell.infoLabel.text = comm.doc.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQMeComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];
    if (comm.cacheHeight <= CGFLOAT_MIN) {
        CGFloat cellHeight = [LQMeCommsCell staticHeight];
        cellHeight += [comm.content sizeWithFont:[UIFont lqsFontOfSize:30] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
        cellHeight += [comm.doc.title sizeWithFont:[UIFont lqsFontOfSize:28] byWidth:CGRectGetWidth(self.view.bounds)-70].height;
        comm.cacheHeight = cellHeight;
    }
    return comm.cacheHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQMeComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];

    LQDetailInfomationViewCtrl *infomationViewCtrl = [[LQDetailInfomationViewCtrl alloc] init];
    infomationViewCtrl.requestURL = comm.doc.url;
    infomationViewCtrl.infoObj = comm.doc;
    [self.navigationController pushViewController:infomationViewCtrl animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除\n评论";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self)
    [self alertViewShowWithTitle:nil
                         message:@"是否删除此评论？"
                          cancel:@"否"
                           other:@"是"
                    clickedBlock:^(BOOL isTrue) {
                        if (!isTrue) {return ; }
                        @strongify(self)
                        LQMeComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];
                        LQDeleteCommReq *req = [[LQDeleteCommReq alloc] init];
                        req.commId = comm.id;
                        [self.view showActivityViewWithTitle:nil];
                        [req requestWithCompletion:^(id response) {
                            [self.view hiddenActivity];
                            [self.tableView.mj_header beginRefreshing];
                        } error:^(id error) {
                            [self.view hiddenActivityWithTitle:@"删除失败"];
                        }];
                    }];
}
    
    


@end
