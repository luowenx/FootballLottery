//
//  LQPanWebFooterView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/12.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPlanDetailHeader.h"

/**
 *  方案详情webfooter
 *  显示详情不会有支付按钮，因此不用适配iPhoneX底下安全距离
 */
@interface LQPlanWebFooterView : UIView

@property (nonatomic) LQPlanDetailShowType showType;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) void (^updataHeight)(CGFloat height);

-(void)loadWithHTMLString:(NSString*)HTML baseUrl:(NSURL*)url;

// 总高度
-(CGFloat)totalHeight;

@end
