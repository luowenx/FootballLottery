//
//  LQBeanView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/18.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 豆子视图 、大小由内部子视图撑开
 */
@interface LQBeanView : UIView
// 豆子数量
@property (nonatomic, strong, readonly) UILabel *beanLabel;

// 豆子图片
@property (nonatomic, strong, readonly) UIImageView * beanImageView;

@end
