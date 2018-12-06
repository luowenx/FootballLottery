//
//  LQFeedbackVC.m
//  看片侠
//
//  Created by lequwuxian1 on 2017/10/18.
//  Copyright © 2017年 lequwuxian1. All rights reserved.
//

#import "LQFeedbackVC.h"

#import "LQFeedbacksReq.h"

@interface LQFeedbackVC ()<UITextViewDelegate>


@property(nonatomic,strong)UITextView * textView;

@property (nonatomic, strong)UILabel *tip, *count;

@end

@implementation LQFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
}

- (void)creatUI
{
    self.title = @"意见反馈";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    //创建textView
    _textView = [UITextView newAutoLayoutView];
    _textView.text=@"请输入您遇到的问题或者建议，谢谢您的支持！";
    _textView.font=[UIFont systemFontOfSize:16];
    _textView.textColor=[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
    _textView.delegate=self;
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView setCornerRadius:3 borderColor:UIColorFromRGB(0xa2a2a2) borderWidth:.5];
    [self.view addSubview:_textView];
    [_textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 18, 0, 18) excludingEdge:ALEdgeBottom];
    [_textView autoSetDimension:ALDimensionHeight toSize:153];
    
//    [self.view addSubview:self.count];
//    [_count autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_textView withOffset:15];
//    [_count autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_textView];

    
    UIButton *submitBtn = [UIButton newAutoLayoutView];
    [submitBtn setBackgroundColor:[UIColor flsMainColor]];
    [submitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.view addSubview:submitBtn];
    [submitBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [submitBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [submitBtn autoSetDimension:ALDimensionHeight toSize:51];
    if (is_iPhoneX) {
        UIView *iphoneX = [UIView newAutoLayoutView];
        iphoneX.backgroundColor = [UIColor flsMainColor];
        [self.view addSubview:iphoneX];
        [iphoneX autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [iphoneX autoSetDimension:ALDimensionHeight toSize:kLQSafeBottomHeight];
        [submitBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSafeBottomHeight];
    }else{
        [submitBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    
    @weakify(self)
    [[submitBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        if (self_weak_.textView.text.length < 5) {
            [LQJargon hiddenJargon:@"请输入不少于5个字"];
            return ;
        }
        LQFeedbacksReq *req = [[LQFeedbacksReq alloc] init];
        req.content = self_weak_.textView.text;
        [self_weak_.view showActivityViewWithTitle:nil];
        [req requestWithCompletion:^(id response) {
            LQNetResponse *res = (LQNetResponse *)response;
            if (res.ret == kLQNetResponseSuccess) {
                [self_weak_.view hiddenActivityWithTitle:@"反馈成功"];
                [self_weak_.navigationController popViewControllerAnimated:YES];
            }else if (res.ret == kLQNetResponseNeedLogin){
                [self_weak_.view hiddenActivityWithTitle:@"反馈失败，请登录后重试"];
            }  else{
                [self_weak_.view hiddenActivityWithTitle:@"反馈失败"];
            }
        } error:^(NSError *error) {
            [self_weak_.view hiddenActivityWithTitle:@"反馈失败"];
        }];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入您遇到的问题或者建议，谢谢您的支持！"]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请输入您遇到的问题或者建议，谢谢您的支持！";
        textView.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
    }
}

- (UILabel *)count {
    
    if (!_count) {
        _count = [UILabel newAutoLayoutView];
        _count.textColor = [UIColor colorWithRed:0/255.0 green:220/255.0 blue:255/255.0 alpha:1.0];
        _count.attributedText = [self setMutableStringWithString:@"0/180"];
    }
    return _count;
}

#pragma mark - 富文本的子方法
- (NSMutableAttributedString *)setMutableStringWithString:(NSString *)string {
    
    NSRange replaceRange = [string rangeOfString:@"/180"];
    NSMutableAttributedString *words = [[NSMutableAttributedString alloc]initWithString:string];
    
    [words addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0] range:replaceRange];
    
    return words;
    
}

#pragma mark - textView代理方法
// 该方法只要输入发生变化就会被执行
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    LQLog(@"之前的长度 %ld, 从何处修改%ld, 修改的长度%ld, 替代文字的长度%ld",textView.text.length, range.location,range.length, text.length);
    
    NSInteger currentwords = textView.text.length - range.length + text.length ;
    
    
    //添加字符
    if (![text isEqualToString:@""]) {  //提示隐藏
        self.tip.hidden = YES;
        
        //判断是否大于20，并同步字数显示
        if (currentwords > 1024) {
            
//            UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:@"超出最大可输入长度" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alertview addAction:defult];
//
//            [self presentViewController:alertview animated:YES completion:nil];
            
            return NO;
            
        }else {
            //添加字符时
//            self.count.attributedText = [self setMutableStringWithString:[NSString stringWithFormat:@"%ld/180",(long)currentwords]];
        }
        
    }
    
    //删除字符
    if ([text isEqualToString:@""] && range.length > 0) {
//        self.count.attributedText = [self setMutableStringWithString:[NSString stringWithFormat:@"%ld/180",(long)currentwords]];
        if (currentwords == 0) {
            self.tip.hidden = NO;
        }
    }
    
    return YES;
}

@end
