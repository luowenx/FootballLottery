//
//  AppDelegate.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIToolbar * maskView;

@end


@interface AppDelegate (UM)

/**
 友盟初始化
 */
-(void)initUM;

// 是否是UM处理
- (BOOL)um_application:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (BOOL)um_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

- (BOOL)um_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

@interface AppDelegate (UI)

- (void)initWindow;
-(void)coverMaskView;
-(void)recoverMaskView;
@end

