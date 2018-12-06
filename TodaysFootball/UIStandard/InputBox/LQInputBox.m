//
//  LQInputBox.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQInputBox.h"

@interface LQInputBox ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *innerTextView;
@property (nonatomic, strong) UIView *actionBackgroundView;
@property (nonatomic, strong) UILabel *showTextLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *externButton;

@property (nonatomic, strong) NSLayoutConstraint *selfHeightCons;

@end

@implementation LQInputBox
{
    BOOL isHidden_;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _selfHeightCons = [self autoSetDimension:ALDimensionHeight toSize:50 + kLQSafeBottomHeight];
        
        _actionBackgroundView = [UIView newAutoLayoutView];
        _actionBackgroundView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _actionBackgroundView.userInteractionEnabled = YES;
        [_actionBackgroundView setCornerRadius:20 borderColor:[UIColor flsSpaceLineColor] borderWidth:1.0];
        [self addSubview:_actionBackgroundView];
        [_actionBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingLarge];
        [_actionBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSMarginMax];
        [_actionBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingSmall];
        [_actionBackgroundView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSPaddingSmall + kLQSafeBottomHeight];
        
        _showTextLabel = [UILabel newAutoLayoutView];
        _showTextLabel.userInteractionEnabled = YES;
        _showTextLabel.textColor = [UIColor flsCancelColor];
        _showTextLabel.textAlignment = NSTextAlignmentLeft;
        _showTextLabel.text = @"写评论...";
        _showTextLabel.font = [UIFont lqsFontOfSize:28];
        [_actionBackgroundView addSubview:_showTextLabel];
        [_showTextLabel autoCenterInSuperview];
        [_showTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingLarge];
        
        _externButton = [UIButton newAutoLayoutView];
        [_externButton setImage:imageWithName(@"info_comm_enter") forState:(UIControlStateNormal)];
        [self addSubview:_externButton];
        [_externButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingLarge];
        [_externButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_actionBackgroundView];
        
        _innerTextView = [UITextView newAutoLayoutView];
        _innerTextView.hidden = YES;
        _innerTextView.delegate = self;
        _innerTextView.font = [UIFont lqsFontOfSize:30];
        _innerTextView.returnKeyType = UIReturnKeySend;
        [_innerTextView setCornerRadius:2 borderColor:[UIColor flsSpaceLineColor] borderWidth:1.0];
        [self addSubview:_innerTextView];
        [_innerTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLQSPaddingLarge];
        [_innerTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kLQSPaddingLarge];
        [_innerTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLQSPaddingSmall];
        [_innerTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSPaddingSmall];
        
        _placeholderLabel = [UILabel newAutoLayoutView];
        _placeholderLabel.textColor = [UIColor flsCancelColor];
        _placeholderLabel.font = [UIFont lqsFontOfSize:30];
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.hidden = YES;
        [self.innerTextView addSubview:_placeholderLabel];
        [_placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_innerTextView.textContainerInset.top];
        [_placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:_innerTextView.textContainerInset.right];
        [_placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:_innerTextView.textContainerInset.left + 5];

        UIView *lineTop = [UIView newAutoLayoutView];
        lineTop.backgroundColor = [UIColor flsSpaceLineColor];
        [self addSubview:lineTop];
        [lineTop autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [lineTop autoSetDimension:ALDimensionHeight toSize:1.0];
        
        @weakify(self)
        [_showTextLabel addTapGestureWithBlock:^(UIView *gestureView) {
            @strongify(self)
            self.actionBackgroundView.hidden = YES;
            self.innerTextView.hidden = NO;
            [self.innerTextView becomeFirstResponder];
        }];
        
        [[_externButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self)
            if (self.comment) {
                self.comment();
            }
        }];
        
//        isHidden_ = YES;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        if (textView.text.length<=0) {            
            return NO;
        }
        
        if (self.send) {
            self.send(textView.text);
        }
        textView.text = nil;
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark  ===  public

-(void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length>0) {
        _placeholder = placeholder;
        self.placeholderLabel.text = placeholder;
    }
}

-(void)annimationWithKeyboardFrame:(CGRect)keyboardFrame
{
//    if (!isHidden_) {
//        return;
//    }
//    isHidden_ = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.selfHeightCons.constant = 100;
        self.bottomCons.constant = -keyboardFrame.size.height;
        [self.superview layoutIfNeeded];
    }];
    [self textViewDidChange:self.innerTextView];
}

-(void)hiddenBox
{
//    if (isHidden_) {
//        return;
//    }
//    isHidden_ = YES;
    self.actionBackgroundView.hidden = NO;
    self.innerTextView.hidden = YES;
    self.placeholderLabel.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.selfHeightCons.constant = 50 + kLQSafeBottomHeight;
        self.bottomCons.constant = 0;
    }];
}

-(NSString *)text
{
    return self.innerTextView.text;
}



@end
