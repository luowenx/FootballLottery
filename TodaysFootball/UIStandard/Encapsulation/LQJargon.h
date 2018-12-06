//
//  LQJargon.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/2.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  黑色提示 (Window最上层)
 */
@interface LQJargon : UIView

+(void)hiddenJargon:(NSString *)message;
+(void)hiddenJargon:(NSString *)message delayed:(NSTimeInterval)delay;


+(void)showJargon:(NSString *)message;
+ (void)hiddenJargon;

@end
