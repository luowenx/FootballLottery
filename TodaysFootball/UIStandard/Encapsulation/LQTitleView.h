//
//  LQTitleView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/4.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 标题视图
 */
@interface LQTitleView : UIView
@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
// size(44, 44)
@property (nonatomic, strong, readonly) UIButton *leftButton;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *titleView;

-(void)updateLeftTitle:(NSString *)leftTitle handler:(void(^)(UIButton *sender))handler;

-(void)updateLeftImageName:(NSString *)leftImage handler:(void(^)(UIButton *sender))handler;

@end
