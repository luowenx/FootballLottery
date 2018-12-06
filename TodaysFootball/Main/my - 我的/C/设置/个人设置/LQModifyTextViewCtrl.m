//
//  LQModifyTextViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQModifyTextViewCtrl.h"

@interface LQModifyTextViewCtrl ()

@property (nonatomic, strong) UIButton * saveBtn;
@property (nonatomic, strong) UITextField *textFeild;
@end

@implementation LQModifyTextViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self)
    [self addLeftNavWithTitle:@"取消" hander:^{
        [self_weak_.navigationController popViewControllerAnimated:YES];
    }];
    
    _saveBtn = [self addRightNavWithTitle:@"保存" hander:^{
        if (self_weak_.save) {
            self_weak_.save(self_weak_.textFeild.text);
        }
        [self_weak_.navigationController popViewControllerAnimated:YES];
    }];
    _saveBtn.enabled = NO;
    
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UIView *whiteView = [UIView newAutoLayoutView];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [whiteView autoSetDimension:ALDimensionHeight toSize:60];
    
    UITextField *textFeild = [UITextField newAutoLayoutView];
    textFeild.textColor = [UIColor grayColor];
    textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFeild.text = self.initialText?:@"";
    [whiteView addSubview:textFeild];
    [textFeild autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [textFeild becomeFirstResponder];
    
    _textFeild = textFeild;
    @weakify(self)
    [[[RACObserve(textFeild, text) merge:textFeild.rac_textSignal]skip:3] subscribeNext:^(id x) {
        NSString *text = (NSString*)x;
        self_weak_.saveBtn.enabled  = text.length>0;
    }];
    
}

- (void)textFieldEditChangedNotification:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isEqual:self.textFeild]) {
        return;
    }
    // 长度限制
    [textField inputConstraints:16 autoIntercept:YES whitespace:NO];
}

@end
