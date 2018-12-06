//
//  LQMatchAllFollowVC.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 赛事--全部
 */
@class LQFilterConfiger;
@interface LQMatchAllFollowVC : UIViewController

/**
 当前筛选对象
 */
@property (nonatomic, strong, readonly) LQFilterConfiger * filterConfiger;

-(void)setFilterConfiger:(LQFilterConfiger *)filterConfiger;

@end
