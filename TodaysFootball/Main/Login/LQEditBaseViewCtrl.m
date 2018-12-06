//
//  LQEditBaseViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQEditBaseViewCtrl.h"

@interface LQEditBaseViewCtrl ()

@end

@implementation LQEditBaseViewCtrl
{
    UIButton *_closeKeyBoardButton;
}

-(instancetype)initWithSubViewOption:(LQLoginEditingSubViewOption)subViewOption
{
    self = [super init];
    if (self) {
        _subViewOption = subViewOption;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self alertViewShowWithMessage:nil cancel:nil];
//    UITabBarController *rootViewCtrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//   UIViewController *firstVC = rootViewCtrl.viewControllers.firstObject;
//    firstVC.tabBarItem.badgeValue = @"红点";

    [self _initUI];
    [self _initHandler];
    [self addObserver];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)_initUI
{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _closeKeyBoardButton = [UIButton newAutoLayoutView];
    [self.view addSubview:_closeKeyBoardButton];
    [_closeKeyBoardButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIView *previouView = self.navigationController.navigationBar;
    if ((self.subViewOption & LQLoginEditingSubViewOptionAccountNumber)==LQLoginEditingSubViewOptionAccountNumber) {
        UILabel *phoneLabel = [UILabel newAutoLayoutView];
        phoneLabel.text = @"手机号";
        phoneLabel.textColor = UIColorFromRGB(0x404040);
        phoneLabel.font = [UIFont lqsFontOfSize:30];
        [self.view addSubview:phoneLabel];
        [phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired+1) forConstraints:^{
            [phoneLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        }];
        
        _phoneTextFeild = [UITextField newAutoLayoutView];
        _phoneTextFeild.placeholder = @"请输入手机号";
        _phoneTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextFeild.font = [UIFont lqsFontOfSize:30];
        [self.view addSubview:_phoneTextFeild];
        
        [_phoneTextFeild autoAlignAxis:ALAxisHorizontal toSameAxisOfView:phoneLabel];
        [_phoneTextFeild autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:phoneLabel withOffset:10];
        [_phoneTextFeild autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_phoneTextFeild autoSetDimension:ALDimensionHeight toSize:40];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneLabel withOffset:10];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:phoneLabel];
        [line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_phoneTextFeild];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        
        previouView = _phoneTextFeild;
    }
    
    if ((self.subViewOption & LQLoginEditingSubViewOptionVerificationCode) == LQLoginEditingSubViewOptionVerificationCode) {
        
        UILabel *codeLabel = [UILabel newAutoLayoutView];
        codeLabel.textColor = UIColorFromRGB(0x404040);
        codeLabel.text = @"验证码";
        codeLabel.font = [UIFont lqsFontOfSize:30];
        [self.view addSubview:codeLabel];
        [codeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [codeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previouView withOffset:15];
        
        _codeTextFeild = [UITextField newAutoLayoutView];
        _codeTextFeild.placeholder = @"请输入验证码";
        _codeTextFeild.font = [UIFont lqsFontOfSize:30];
        [self.view addSubview:_codeTextFeild];
        [_codeTextFeild autoSetDimension:ALDimensionHeight toSize:35];
        [_codeTextFeild autoSetDimension:ALDimensionWidth toSize:150];
        [_codeTextFeild autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:codeLabel withOffset:10];
        [_codeTextFeild autoAlignAxis:ALAxisHorizontal toSameAxisOfView:codeLabel];
        
        _codeButton = [UIButton newAutoLayoutView];
        [_codeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        _codeButton.backgroundColor = [UIColor flsMainColor];
        _codeButton.titleLabel.font = [UIFont lqsFontOfSize:30];
        [_codeButton roundedRectWith:2];
        [_codeButton addTarget:self action:@selector(codeAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_codeButton];
        [_codeButton autoSetDimension:ALDimensionHeight toSize:28];
        [_codeButton autoSetDimension:ALDimensionWidth toSize:104];
        [_codeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_codeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:codeLabel];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeLabel withOffset:10];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:codeLabel];
        [line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_codeButton];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        
        previouView = _codeTextFeild;
    }
    
    if ((self.subViewOption & LQLoginEditingSubViewOptionPassword)==LQLoginEditingSubViewOptionPassword) {
        UILabel *nickNameLabel = [UILabel newAutoLayoutView];
        nickNameLabel.text = @"昵   称";
        nickNameLabel.textColor = [UIColor grayColor];
        [self.view addSubview:nickNameLabel];
        [nickNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previouView withOffset:15];
        [nickNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];

        _passwordTextFeild = [UITextField newAutoLayoutView];
        _passwordTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_passwordTextFeild];
        [_passwordTextFeild autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previouView];
        [_passwordTextFeild autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_passwordTextFeild autoSetDimension:ALDimensionHeight toSize:35];
        [_passwordTextFeild autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nickNameLabel];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nickNameLabel withOffset:5];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
        [line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordTextFeild];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        
        previouView = _passwordTextFeild;
    }
    
    if ((self.subViewOption & LQLoginEditingSubViewOptionConfirm)==LQLoginEditingSubViewOptionConfirm) {
        _confirmButton = [UIButton newAutoLayoutView];
        _confirmButton.backgroundColor = [UIColor whiteColor];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _confirmButton.titleLabel.font = [UIFont lqsFontOfSize:30];
        [_confirmButton setBackgroundColor:[UIColor flsMainColor]];
        [_confirmButton roundedRectWith:4];
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_confirmButton];
        [_confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previouView withOffset:30];
        [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:57];
        [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:57];
        [_confirmButton autoSetDimension:ALDimensionHeight toSize:37];
    }

}

- (void)_initHandler
{
    @weakify(self)
    [[_closeKeyBoardButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_.view endEditing:YES];
    }];
    
    [RACObserve(_confirmButton, enabled) subscribeNext:^(id x) {
        BOOL enable = [x boolValue];
        if (enable) {
            self_weak_.confirmButton.backgroundColor = [UIColor flsMainColor];
        }else{
            self_weak_.confirmButton.backgroundColor = UIColorFromRGB(0xcccccc);
        }
    }];
    
    [RACObserve(_codeButton, enabled) subscribeNext:^(id x) {
        BOOL enable = [x boolValue];
        if (enable) {
            self_weak_.codeButton.backgroundColor = [UIColor flsMainColor];
        }else{
            self_weak_.codeButton.backgroundColor = UIColorFromRGB(0xcccccc);
        }
    }];
}

- (void)textFieldEditChangedNotification:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isEqual:self.phoneTextFeild] &&
        ![textField isEqual:self.codeTextFeild] &&
        ![textField isEqual:self.passwordTextFeild]) {
        return;
    }
    // 长度限制
    [textField inputConstraints:[self maxTextNumberTheTextFeild:textField] autoIntercept:YES whitespace:NO];
}

- (void)hideKeyboardAction
{
    [self.view endEditing:YES];
}

#pragma mark  === public
- (NSInteger)maxTextNumberTheTextFeild:(UITextField *)textField
{
    return 11;
}

- (void)confirmAction
{
}

- (void)codeAction
{
}


@end
