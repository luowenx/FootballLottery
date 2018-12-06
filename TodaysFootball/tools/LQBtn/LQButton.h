//
//  LQButton.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LQButton;
//传一个参数，这个参数最好是当前按钮自身，这样可以将按钮的所有属性都传出去
typedef void (^myBlock)(LQButton *button);

@interface LQButton : UIButton

@property (nonatomic,copy) myBlock tempBlock;

+(LQButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType )type title:(NSString *)title titleColor:(UIColor *)color backgroundImage:(NSString *)image1 andBlock:(myBlock)block;
@end
