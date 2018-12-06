//
//  LQSelectorViewCtrl.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBaseViewCtrl.h"


/**
 选择器控制器
 */
@interface LQSelectorViewCtrl : LQBaseViewCtrl

/**
 选中回调
 */
@property (nonatomic, copy) void (^selecting)(NSInteger index);

// 所有选项
@property (nonatomic, copy) NSArray *dataArray;

// 所选中选项， 传-1表示 没有选中的
@property (nonatomic) NSInteger  selectedIndex;

@end
