//
//  LQInfoCommsViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInfoCommsViewCtrl.h"

#import "LQInfoCommtsCell.h"

#import "LQInformation.h"
#import "LQCommsReq.h"
#import "LQInfoComment.h"

@interface LQInfoCommsViewCtrl ()

@end

@implementation LQInfoCommsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)getDataisRefresh:(BOOL)isRefresh
{
    NSInteger limit = 10;
    NSInteger offset = isRefresh? 0 : self.dataList.count;
    LQCommsReq *req = [[LQCommsReq alloc] init];
    req.docId = self.info.docId;
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
        NSArray *datalist = [LQInfoComment objArrayWithDics:(NSArray<NSDictionary *> *)res.data];
        if (datalist.count > 0) {
            [self.dataList addObjectsFromArray:datalist];
        }
        [self.tableView reloadData];
        
        if (datalist.count < limit) {
            self.tableView.mj_footer.hidden = YES;
        }
        if (self.dataList.count <= 0) {
            UIView *empty = [self showEmptyViewImageName:@"empty_1" title:@"暂时还没有评论哦~~"];
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
    LQInfoCommtsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQInfoCommtsCell"];
    if (!cell) {
        cell = [[LQInfoCommtsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LQInfoCommtsCell"];
    }
    LQInfoComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:comm.user.avatar]
                          placeholderImage:LQPlaceholderIcon];
    if ([comm.user.gender  isEqual: @"1"]) {
        cell.genderImageView.image = imageWithName(@"Profile_manIcon");
    }else{
        cell.genderImageView.image = imageWithName(@"Profile_womanIcon");
    }
    cell.timeLabel.text = [NSString stringFormatIntervalSince1970_YearMonthDayHourMinuteSecond_Line:[comm.commentTime doubleValue]];
    cell.nameLabel.text = stringNotNil(comm.user.nickName);
    cell.contentLabel.text = stringNotNil(comm.content);
    
    cell.externButton.selected = [userManager containsComm:comm];
    
    [[[cell.externButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
      takeUntil:cell.rac_prepareForReuseSignal]
     subscribeNext:^(UIButton *externButton) {
         [userManager praiseComm:comm];
         externButton.selected = [userManager containsComm:comm];
    }];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LQInfoComment *comm = [self.dataList safeObjectAtIndex:indexPath.row];
    if (comm.cacheHeight <= CGFLOAT_MIN) {
        CGFloat cellHeight = [LQInfoCommtsCell staticHeight];
        cellHeight += [comm.content sizeWithFont:[UIFont lqsFontOfSize:30] byWidth:CGRectGetWidth(self.view.bounds)-34].height;
        comm.cacheHeight = cellHeight;
    }
    return comm.cacheHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self sheetShowWithTitle:nil
                      cancel:@"取消"
                       other:@[@"举报"]
                clickedBlock:^(id index) {
                    
                    if ([index integerValue] == 0) {
                        [LQJargon hiddenJargon:@"已举报" delayed:0.5];
                    }
                    
                }];
}



@end
