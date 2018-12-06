//
//  LQMatchTagView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/26.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 标签视图
 */
@interface LQMatchTagView : UIView


/**
 刷新标签

 @param tags title数组
 @param setTitle 设置标题
 */
-(void)reloadTags:(nullable NSArray *)tags setTitle:(NSString * (^)(id obj))setTitle;

@end

NS_ASSUME_NONNULL_END
