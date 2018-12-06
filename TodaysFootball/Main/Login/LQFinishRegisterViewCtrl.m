//
//  LQFinishRegisterViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/13.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFinishRegisterViewCtrl.h"

@interface LQFinishRegisterViewCtrl ()

@end

@implementation LQFinishRegisterViewCtrl

-(instancetype)init
{
    return [super initWithSubViewOption:
            LQLoginEditingSubViewOptionAccountNumber |
            LQLoginEditingSubViewOptionPassword |
            LQLoginEditingSubViewOptionConfirm];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void) initUI
{
    self.title = @"完成注册";
    
    [self.confirmButton setTitle:@"完成" forState:(UIControlStateNormal)];
    self.passwordTextFeild.placeholder = @"请输入昵称";
    
    self.phoneTextFeild.enabled = NO;
    
    self.phoneTextFeild.text = self.phoneNum;
    
    
    @weakify(self)
    [[[self.phoneTextFeild.rac_textSignal merge:RACObserve(self.phoneTextFeild, text)]
      combineLatestWith:[self.passwordTextFeild.rac_textSignal merge:RACObserve(self.passwordTextFeild, text)]]subscribeNext:^(RACTuple *tup) {
        NSString *accountNumber = tup.first;
        NSString *verificationCode = tup.second;
        self_weak_.confirmButton.enabled = (accountNumber.length > 0 && verificationCode.length > 0);
    }] ;
    
}

-(void)confirmAction
{
    [self hideKeyboardAction];
    LQUserInfo *info = [[LQUserInfo alloc] init];
    info.nickName = self.passwordTextFeild.text;
    
    userManager.currentUser = info;
    [userManager saveCurrentUser];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
