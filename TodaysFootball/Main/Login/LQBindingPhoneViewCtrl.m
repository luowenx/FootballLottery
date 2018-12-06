//
//  LQBindingPhoneViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQBindingPhoneViewCtrl.h"

#import "LQGetVerifyCodeReq.h"
#import "LQBindingReq.h"

@interface LQBindingPhoneViewCtrl ()

@end

@implementation LQBindingPhoneViewCtrl{
    RACDisposable *disposable;
}

-(instancetype)init
{
    return [super initWithSubViewOption:(LQLoginEditingSubViewOptionAccountNumber
            |LQLoginEditingSubViewOptionVerificationCode
            |LQLoginEditingSubViewOptionConfirm)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)onBack
{
    [super onBack];
    [disposable dispose];
    disposable = nil;
}

-(void)initUI
{
    self.title = @"绑定手机号";
    
    self.phoneTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextFeild.keyboardType = UIKeyboardTypeNumberPad;

    [self.confirmButton setTitle:@"绑定" forState:(UIControlStateNormal)];
    
    @weakify(self)
    [[[self.phoneTextFeild.rac_textSignal merge:RACObserve(self.phoneTextFeild, text)]
      combineLatestWith:[self.codeTextFeild.rac_textSignal merge:RACObserve(self.codeTextFeild, text)]]subscribeNext:^(RACTuple *tup) {
        NSString *accountNumber = tup.first;
        NSString *verificationCode = tup.second;
        self_weak_.confirmButton.enabled = (accountNumber.length > 0 && verificationCode.length > 0);
    }] ;
}


- (NSInteger)maxTextNumberTheTextFeild:(UITextField *)textField
{
    if (textField == self.phoneTextFeild) {
        return 11;
    }
    return [super maxTextNumberTheTextFeild:textField];
}

-(void)codeAction
{
    [self hideKeyboardAction];
    if ([NSString validateTel:self.phoneTextFeild.text] != isRight) { // 校验手机号
        [self.view showActivityViewWithTitle:@"手机号格式不正确"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view hiddenActivity];
        });
        return;
    }
    
    LQGetVerifyCodeReq *req = [[LQGetVerifyCodeReq alloc] init];
    req.mobile = self.phoneTextFeild.text;
    [self.view showActivityViewWithTitle:nil];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == kLQNetResponseGetVerifycodeError) {
            [self.view showActivityViewWithTitle:@"发送验证码失败" ];
        }else{
            [self.view hiddenActivity];
        }
    }  error:nil];
    
    __block NSInteger count = 60;
    if (disposable && !disposable.isDisposed) {
        [disposable dispose];
        disposable = nil;
    }
    @weakify(self)
    disposable = [ [[[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]startWith:nil] takeUntil:self.rac_willDeallocSignal] takeUntilBlock:^BOOL(id x) {
        return count < -1;
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view hiddenActivity];
        });
        return;
    }
    
    LQBindingReq *req = [[LQBindingReq alloc] init];
    req.mobile = self.phoneTextFeild.text;
    req.verifycode = self.codeTextFeild.text;
    [self.view showActivityViewWithTitle:nil];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == kLQNetResponseHasBinding) {
            [self.view hiddenActivityWithTitle:@"该手机号已经绑定"];
        }else if (res.ret == kLQNetResponseVerifycodeInconformity){
            [self.view hiddenActivityWithTitle:@"验证码错误"];
        }else if (res == kLQNetResponseSuccess) {
            [self.view hiddenActivityWithTitle:@"绑定成功"];
            userManager.currentUser.mobile = req.mobile;
            [userManager saveCurrentUser];
            [self onBack];
        }else{
            [self.view hiddenActivityWithTitle:res.msg];
        }
    } error:nil];

}




@end
