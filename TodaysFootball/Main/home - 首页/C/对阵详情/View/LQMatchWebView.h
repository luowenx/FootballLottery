//
//  LQMatchWebView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQSwichCtrl, WKWebView;

/**
 WKWebView 有使用桥接、
 */
@class LQBaseViewCtrl;
@interface LQMatchWebView : UIView

@property (nonatomic, strong) LQSwichCtrl * swichCtrl;

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, copy) NSString * urlStrl;

@property (nonatomic, weak) LQBaseViewCtrl * linkViewCtrl;

@property (nonatomic) CGFloat judgementOffset;

// 重新load  webView
-(void)reloadWebView;

/**
 swichCtrl高度

 @return <#return value description#>
 */
-(CGFloat) swichCtrlHeight;

/**
 隐藏 SwichCtrl
 */
-(void)hiddenSwichCtrl;


-(void)enableWebViewScrolled;
-(void)disEnableWebViewScrolled;

@end
