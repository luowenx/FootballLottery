//
//  LQJargon.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/2.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQJargon.h"

LQJargon *jargon = nil;
RACDisposable *disposable = nil;
@implementation LQJargon

+(void)showJargon:(NSString *)message
{
    [LQJargon removeJargon];
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    CGSize contentSize = [message getSizeWithConntainSize:CGSizeMake(200, 1000) font:[UIFont lqsFontOfSize:30]];
    CGRect  jargonframe = CGRectMake(0, 0, contentSize.width + contentEdgeInsets.left + contentEdgeInsets.right, contentSize.height +contentEdgeInsets.top + contentEdgeInsets.bottom );
    
    jargon = [[LQJargon alloc] initWithFrame:jargonframe];
    [jargon roundedRectWith:3];
    [[UIApplication sharedApplication].keyWindow addSubview:jargon];
    jargon.center = CGPointMake(UIDeviceScreenWidth * .5, UIDeviceScreenHeight * .5);
    jargon.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentEdgeInsets.left, contentEdgeInsets.top, contentSize.width, contentSize.height)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont lqsFontOfSize:30];
    contentLabel.text = message;
    [jargon addSubview:contentLabel];
}

+(void)removeJargon
{
    if (jargon) {
        [jargon removeFromSuperview];
        jargon = nil;
    }
    
    if (disposable && !disposable.isDisposed) {
        [disposable dispose];
        disposable = nil;
    }
}

+(void)hiddenJargon:(NSString *)message delayed:(NSTimeInterval)delay
{
    [LQJargon removeJargon];

    [LQJargon showJargon:message];
    
    disposable = [[RACSignal interval:delay onScheduler:([RACScheduler mainThreadScheduler])] subscribeNext:^(id x) {
        [LQJargon removeJargon];
    }];
}

+(void)hiddenJargon:(NSString *)message
{
    [LQJargon hiddenJargon:message delayed:2];
}


+ (void)hiddenJargon
{
    [LQJargon removeJargon];
}


@end
