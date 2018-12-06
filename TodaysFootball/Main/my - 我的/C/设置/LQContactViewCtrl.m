//
//  LQContactViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQContactViewCtrl.h"

@interface LQContactViewCtrl ()

@end

@implementation LQContactViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    
    UILabel *businessAffairsLabel = [UILabel newAutoLayoutView];
    businessAffairsLabel.font = [UIFont lqsFontOfSize:32 isBold:YES];
    businessAffairsLabel.text = @"商务合作：";
    [self.view addSubview:businessAffairsLabel];
    [businessAffairsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    [businessAffairsLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:63];
    
    UILabel *businessAffairs = [UILabel newAutoLayoutView];
    businessAffairs.font = [UIFont lqsFontOfSize:30 isBold:YES];
    businessAffairs.text = @"010-65104728";
    businessAffairs.userInteractionEnabled = YES;
    [self.view addSubview:businessAffairs];
    [businessAffairs autoAlignAxis:ALAxisHorizontal toSameAxisOfView:businessAffairsLabel];
    [businessAffairs autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:businessAffairsLabel withOffset:0];
    
    UILabel *e_mailLabel = [UILabel newAutoLayoutView];
    e_mailLabel.text = @"合作邮箱：";
    e_mailLabel.font = [UIFont lqsFontOfSize:32 isBold:YES];
    [self.view addSubview:e_mailLabel];
    [e_mailLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    [e_mailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:businessAffairsLabel withOffset:22];
    
    UILabel *e_mail = [UILabel newAutoLayoutView];
    e_mail.font = [UIFont lqsFontOfSize:30 isBold:YES];
    e_mail.text = @"chenyaxian@lequwuxian.cn";
    e_mail.userInteractionEnabled = YES;
    [self.view addSubview:e_mail];
    [e_mail autoAlignAxis:ALAxisHorizontal toSameAxisOfView:e_mailLabel];
    [e_mail autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:e_mailLabel withOffset:0];
    
    UILabel *QQLabel = [UILabel newAutoLayoutView];
    QQLabel.text = @"客服时间：";
    QQLabel.font = [UIFont lqsFontOfSize:32 isBold:YES];
    [self.view addSubview:QQLabel];
    [QQLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    [QQLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:e_mailLabel withOffset:22];
    
    UILabel *qq = [UILabel newAutoLayoutView];
    qq.font = [UIFont lqsFontOfSize:30 isBold:YES];
    qq.text = @"周一至周日9:30-18:30";
    [self.view addSubview:qq];
    [qq autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:QQLabel withOffset:0];
    [qq autoAlignAxis:ALAxisHorizontal toSameAxisOfView:QQLabel];
    
    
    [businessAffairs addTapGestureWithBlock:^(UIView *gestureView) {
        UIMenuController * menu = [UIMenuController sharedMenuController];
        [menu setTargetRect: gestureView.bounds inView: gestureView];
        [menu setMenuVisible: YES animated: YES];
    }];
    
    [e_mail addTapGestureWithBlock:^(UIView *gestureView) {
        UIMenuController * menu = [UIMenuController sharedMenuController];
        [menu setTargetRect: gestureView.bounds inView: gestureView];
        [menu setMenuVisible: YES animated: YES];
    }];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

//是否可以成为第一相应
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)copy:(id)sender
{
    UILabel *label = [sender valueForKey:@"_targetView"];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = label.text?:@"";
    
    [LQJargon hiddenJargon:@"复制成功" delayed:1];
}


@end
