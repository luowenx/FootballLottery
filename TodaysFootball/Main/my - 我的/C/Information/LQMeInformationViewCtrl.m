//
//  LQMeInformationViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQMeInformationViewCtrl.h"
#import "LQDetailInfomationViewCtrl.h"

#import "LQInfomationCell.h"

#import "LQInfomationFavoritesReq.h"
#import "LQDeleteFavoriteInfoReq.h"

#import "LQInformation.h"
#import "LQOptionManager.h"

@interface LQMeInformationViewCtrl ()

@end

@implementation LQMeInformationViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self getDataisRefresh:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI
{
    self.title = @"我的资讯";
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self_weak_ getDataisRefresh:NO];
    }];
    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"无更多资讯" forState:(MJRefreshStateNoMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger limit = 10;
    NSInteger offset = isRefresh? 0 : self.dataList.count;
    LQInfomationFavoritesReq *req = [[LQInfomationFavoritesReq alloc] init];
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
        NSArray *datalist = [LQInformation objArrayWithDics:(NSArray<NSDictionary *> *)res.data];
        if (datalist.count > 0) {
            [self.dataList addObjectsFromArray:datalist];
        }
        [self.tableView reloadData];
        
        if (datalist.count < limit) {
            self.tableView.mj_footer.hidden = YES;
        }
        if (self.dataList.count <= 0) {
            UIView *empty = [self showEmptyViewImageName:@"empty_1" title:@"暂未收藏任何资讯"];
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消\n收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQInformation *info = [self.dataList safeObjectAtIndex:indexPath.row];

    @weakify(self)
    [self alertViewShowWithTitle:nil
                         message:@"取消收藏? "
                          cancel:@"否"
                           other:@"是"
                    clickedBlock:^(BOOL isTrue) {
                        if (!isTrue) {return;}
                        @strongify(self)
                        [self.view showActivityViewWithTitle:nil];
                        [LQOptionManager infomationisFavorite:YES
                                                        docId:info.docId
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
