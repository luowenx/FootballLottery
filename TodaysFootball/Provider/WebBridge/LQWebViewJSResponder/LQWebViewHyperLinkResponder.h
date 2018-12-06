//
//  LQWebViewHyperLinkResponder.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/9.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQWebViewJSResponder.h"
/**
 比赛详情专用
 */
@class LQBaseViewCtrl;
@interface LQWebViewHyperLinkResponder : NSObject<LQWebViewJSResponder>

@property (nonatomic, weak) LQBaseViewCtrl * linkViewCtrl;

@end
