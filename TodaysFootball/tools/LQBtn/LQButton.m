//
//  LQButton.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQButton.h"

@implementation LQButton


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)blockButtonclicked:(LQButton *)button{
    //执行block变量
    button.tempBlock(button);
}

+(LQButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)color backgroundImage:(NSString *)image andBlock:(myBlock)block{
    
    LQButton *button = [LQButton buttonWithType:type];
    
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(blockButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    if (image.length) {
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    
    //将参数接收过来,保存到成员变量中
    button.tempBlock = block;
    
    return button;
}

@end
