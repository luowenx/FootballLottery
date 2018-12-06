//
//  LQPhoneRegisterViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPhoneRegisterViewCtrl.h"
#import "LQFinishRegisterViewCtrl.h"

//#import "NSString+Predicate.h"

@interface LQPhoneRegisterViewCtrl ()

@end

@implementation LQPhoneRegisterViewCtrl

-(instancetype)init
{
    return [super initWithSubViewOption:(LQLoginEditingSubViewOptionAccountNumber|LQLoginEditingSubViewOptionVerificationCode|LQLoginEditingSubViewOptionConfirm)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

-(void)initUI
{
    self.title = @"手机号注册";
    self.phoneTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    [self.confirmButton setTitle:@"登录" forState:(UIControlStateNormal)];
    
    @weakify(self)
    [[[self.phoneTextFeild.rac_textSignal merge:RACObserve(self.phoneTextFeild, text)]
      combineLatestWith:[self.codeTextFeild.rac_textSignal merge:RACObserve(self.codeTextFeild, text)]]subscribeNext:^(RACTuple *tup) {
        NSString *accountNumber = tup.first;
        NSString *verificationCode = tup.second;
        self_weak_.confirmButton.enabled = (accountNumber.length > 0 && verificationCode.length > 0);
    }] ;
}

#pragma mark  === 重写父类方法

- (NSInteger)maxTextNumberTheTextFeild:(UITextField *)textField
{
    if (textField == self.phoneTextFeild) {
        return 11;
    }
    return [super maxTextNumberTheTextFeild:textField];
}

-(void)codeAction
{
    __block NSInteger count = 60;
    @weakify(self)
   [ [[[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]startWith:nil] takeUntil:self.rac_willDeallocSignal] takeUntilBlock:^BOOL(id x) {
        return count<-1;
    }] subscribeNext:^(id x) {
        self.codeButton.enabled = NO;
        if (count == -1) {
            self.codeButton.enabled = YES;
            [self_weak_.codeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        }else{
            [self_weak_.codeButton setTitle:[NSString stringWithFormat:@"%@秒", @(count)] forState:(UIControlStateNormal)];
        }
        count --;
    }];
}

-(void)confirmAction
{
    [self hideKeyboardAction];
    if ([NSString validateTel:self.phoneTextFeild.text] != isRight) { // 校验手机号
        [self.view showActivityViewWithTitle:@"手机号格式不正确"];
    }
    
    if (![self.codeTextFeild.text isEqualToString:@"1234"]) { // 校验验证码
        [self.view showActivityViewWithTitle:@"验证码错误"];
    }
    
    // 登录接口
    LQFinishRegisterViewCtrl *finishVC = [[LQFinishRegisterViewCtrl alloc] init];
    finishVC.phoneNum = self.phoneTextFeild.text;
    [self.navigationController pushViewController:finishVC animated:YES];
}

@end
