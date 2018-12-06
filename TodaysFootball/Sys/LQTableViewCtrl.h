//
//  LQTableViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"

/**
 tableViewCtrl  基类
 */
@interface LQTableViewCtrl : LQBaseViewCtrl<UITableViewDelegate, UITableViewDataSource> {
@protected
    NSMutableArray *dataList_; //数据源
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong, readonly) NSMutableArray * dataList;

/**
 *
 * 初始化tableview约束 可覆盖自定义
 */
- (void)initTableConstraints;


-(void)showError:(NSError *)error;

@end
