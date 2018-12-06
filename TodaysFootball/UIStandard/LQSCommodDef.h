//
//  LQSCommodDef.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#ifndef LQSCommodDef_h
#define LQSCommodDef_h

#import "LQAvatarView.h"
#import "LQJargon.h"

/* web页加载超时时间 */
static NSTimeInterval const kWebOvertimeInterval = 5;

//当前屏幕宽度与750屏幕(iphone6)的比例值
#define kLQSScreenFor750Scale      ([UIScreen mainScreen].bounds.size.width  / 375.f)

/**
 *  相对于750屏幕(iphone6)等比缩放
 *
 *  @param a375Point 750屏幕上的点值
 *
 *  @return <#return value description#>
 */
static inline CGFloat lqPointConvertInScreenWidth4EQScale(CGFloat a375Point)
{
    return a375Point * kLQSScreenFor750Scale;
}

/* 外边距、内边距 */
//外边距
static float const kLQSMarginSuper                   = 70.f;
static float const kLQSMarginMax                     = 60.f;
static float const kLQSMarginHuge                    = 50.f;
static float const kLQSMarginLarge                   = 40.f;
static float const kLQSMarginNormal                  = 30.f;
static float const kLQSMarginSmall                   = 20.f;
static float const kLQSMarginMin                     = 15.f;
static float const kLQSMarginTiny                    = 10.f;
//内边距
static float const kLQSPaddingSuper                  = 30.f;
static float const kLQSPaddingMax                    = 25.f;
static float const kLQSPaddingHuge                   = 20.f;
static float const kLQSPaddingSpecial                = 17.f;
static float const kLQSPaddingLarge                  = 15.f;
static float const kLQSPaddingNormal                 = 10.f;
static float const kLQSPaddingSmall                  = 5.f;
static float const kLQSPaddingMin                    = 2.f;
static float const kLQSPaddingTiny                   = 1.f;

#endif /* LQSCommodDef_h */
