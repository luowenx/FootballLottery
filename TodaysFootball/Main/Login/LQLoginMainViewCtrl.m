//
//  LQLoginMainViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/8.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQLoginMainViewCtrl.h"
#import "LQPhoneRegisterViewCtrl.h"
#import "LQStaticWebViewCtrl.h"
#import "LQJSBridgeWebViewCtrl.h"

#import "LQTripartiteView.h"

//#import "NSString+Predicate.h"
#import "LQLoginManager.h"
#import "AppUtils.h"

@interface LQLoginMainViewCtrl ()

@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UITextField * passwordTextField;

@property (nonatomic, strong) LQTripartiteView * tripartiteView;
@property (nonatomic, strong) NSMutableArray * channels;

@end

@implementation LQLoginMainViewCtrl
{
    UIButton *_closeKeyBoardButton;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    @weakify(self)
    [self addLeftNavWithImageName:@"return" hander:^{
        [self_weak_.view endEditing:YES];
        [self_weak_ dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self buildData];
    
    [self initUI];

}

- (void)buildData
{
    self.channels = [NSMutableArray array];
    [self.channels addObject:@{@"image":@"微信登录_light",
                               @"type":@(kLQLoginWayTypeWX) }];
    [self.channels addObject:@{@"image":@"qq登录",
                               @"type":@(kLQLoginWayTypeQQ) }];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _closeKeyBoardButton = [UIButton newAutoLayoutView];
    [self.view addSubview:_closeKeyBoardButton];
    [_closeKeyBoardButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *phoneLable = [UILabel newAutoLayoutView];
    phoneLable.textColor = UIColorFromRGB(0x404040);
    phoneLable.font = [UIFont systemFontOfSize:15];
    phoneLable.text  = @"手机号";
    [self.view addSubview:phoneLable];
    [phoneLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [phoneLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
    [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired+1) forConstraints:^{
        [phoneLable autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
    }];
    
    _phoneTextField = [UITextField newAutoLayoutView];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.font = [UIFont systemFontOfSize:15];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneTextField];
    [_phoneTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:phoneLable];
    [_phoneTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:phoneLable withOffset:10];
    [_phoneTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
    
    UIView *linePhone = [UIView newAutoLayoutView];
    linePhone.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:linePhone];
    [linePhone autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:phoneLable];
    [linePhone autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneLable withOffset:10];
    [linePhone autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_phoneTextField];
    [linePhone autoSetDimension:ALDimensionHeight toSize:0.5];
    
    UILabel *passWordLabel = [UILabel newAutoLayoutView];
    passWordLabel.textColor = UIColorFromRGB(0x404040);
    passWordLabel.font = [UIFont systemFontOfSize:15];
    passWordLabel.text = @"密   码";
    [self.view addSubview:passWordLabel];
    [passWordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [passWordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneLable withOffset:20];
    
    _passwordTextField = [UITextField newAutoLayoutView];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_phoneTextField];
    [_passwordTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:passWordLabel];
    [_passwordTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];

    UIView *linePassword = [UIView newAutoLayoutView];
    linePassword.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:linePassword];
    [linePassword autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:phoneLable];
    [linePassword autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passWordLabel withOffset:10];
    [linePassword autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordTextField];
    [linePassword autoSetDimension:ALDimensionHeight toSize:0.5];

    UIButton *forgetBtn = [UIButton newAutoLayoutView];
    [forgetBtn setTitle:@" 忘记密码?" forState:(UIControlStateNormal)];
    [forgetBtn setTitleColor:[UIColor flsMainColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:forgetBtn];
    [forgetBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:phoneLable];
    [forgetBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passWordLabel withOffset:15];
    
    UIButton *registerBtn = [UIButton newAutoLayoutView];
    [registerBtn setTitle:@"新用户快速注册 >" forState:(UIControlStateNormal)];
    [registerBtn setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:registerBtn];
    [registerBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordTextField];
    [registerBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:forgetBtn];
    
    UIButton *loginBtn = [UIButton newAutoLayoutView];
    [loginBtn setBackgroundColor:[UIColor flsMainColor]];
    [loginBtn roundedRectWith:5];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:loginBtn];
    [loginBtn autoSetDimensionsToSize:CGSizeMake(255, 37)];
    [loginBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [loginBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:forgetBtn withOffset:18];
    
    UIView *agreeContentView = [UIView newAutoLayoutView];
    [self.view addSubview:agreeContentView];
    [agreeContentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginBtn withOffset:10];
    [agreeContentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UIImageView *circleView = [UIImageView newAutoLayoutView];
    circleView.image = imageWithName(@"勾选框");
    [agreeContentView addSubview:circleView];
    [circleView autoSetDimensionsToSize:CGSizeMake(13, 13)];
    [circleView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [circleView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UIButton *agreeImage = [UIButton newAutoLayoutView];
    [agreeImage setBackgroundImage:[UIImage imageNamed:@"对勾"] forState:(UIControlStateSelected)];
    [agreeImage setBackgroundImage:nil forState:(UIControlStateNormal)];
    [agreeContentView addSubview:agreeImage];
    agreeImage.selected = YES;
    [agreeImage autoSetDimensionsToSize:CGSizeMake(13, 13)];
    [agreeImage autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [agreeImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UILabel *agreeLabel = [UILabel newAutoLayoutView];
    agreeLabel.font = [UIFont systemFontOfSize:12];
    agreeLabel.text = @"绑定即视为同意";
    agreeLabel.textColor = UIColorFromRGB(0x7a7a7a);
    [agreeContentView addSubview:agreeLabel];
    [agreeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [agreeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
    [agreeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:agreeImage withOffset:10];
    
    UIButton *agreeBtn = [UIButton newAutoLayoutView];
    NSString *agreeString = [NSString stringWithFormat:@"《%@服务协议》", [AppUtils bundleName]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:agreeString];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor flsMainColor] range:strRange];
    [agreeBtn setAttributedTitle:str forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [agreeContentView addSubview:agreeBtn];
    [agreeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [agreeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:agreeLabel];
    [agreeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _tripartiteView = [[LQTripartiteView alloc] initWithFrame:CGRectZero channels:self.channels];
    [self.view addSubview:_tripartiteView];
    [_tripartiteView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60+(is_iPhoneX?kLQSafeBottomHeight : 0)];
    [_tripartiteView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_tripartiteView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UILabel *tripartiteLabel = [UILabel newAutoLayoutView];
    tripartiteLabel.text = @"使用第三方账号登录";
    tripartiteLabel.font = [UIFont systemFontOfSize:13];
    tripartiteLabel.textColor = UIColorFromRGB(0x404040);
    [self.view addSubview:tripartiteLabel];
    [tripartiteLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tripartiteLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_tripartiteView withOffset:-25];
    
    UIView *line = [UIView newAutoLayoutView];
    line.backgroundColor =UIColorFromRGB(0xcccccc);
    [self.view addSubview:line];
    [line autoSetDimension:ALDimensionHeight toSize:.5];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [line autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_tripartiteView withOffset:-15];

    @weakify(self, loginBtn, agreeImage)
    [[_closeKeyBoardButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self_weak_.view endEditing:YES];
    }];
    
    [RACObserve(loginBtn, enabled) subscribeNext:^(id x) {
        BOOL enable = [x boolValue];
        if (enable) {
            loginBtn_weak_.backgroundColor = [UIColor flsMainColor];
        }else{
            loginBtn_weak_.backgroundColor = [UIColor lightGrayColor];
        }
    }];
    
    [[[self.phoneTextField.rac_textSignal merge:RACObserve(self.phoneTextField, text)]
      combineLatestWith:[self.passwordTextField.rac_textSignal merge:RACObserve(self.passwordTextField, text)]]subscribeNext:^(RACTuple *tup) {
        NSString *accountNumber = tup.first;
        NSString *verificationCode = tup.second;
        loginBtn_weak_.enabled = (accountNumber.length > 0 && verificationCode.length > 0);
    }] ;
    
    [[forgetBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)]subscribeNext:^(id x) {
        // forget
        LQJSBridgeWebViewCtrl *webViewCtrl = [[LQJSBridgeWebViewCtrl alloc] init];
        webViewCtrl.title = @"找回密码";
        webViewCtrl.requestURL = [NSString stringWithFormat:@"%@/auth/forget%@", LQWebURL, LQWebPramSuffix];
        [self_weak_.navigationController pushViewController:webViewCtrl animated:YES];
    }];
    
    [[agreeImage rac_signalForControlEvents:(UIControlEventTouchUpInside)]subscribeNext:^(id x) {
        // agreement
        UIButton *agreeBtn_ = (UIButton* )x;
        agreeBtn_.selected = !agreeBtn_.isSelected;
    }];
    
    [[loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)]subscribeNext:^(id x) {
        if (!agreeImage_weak_.isSelected) {
            [LQJargon hiddenJargon:@"请先阅读用户协议"];
            return ;
        }
        // login
        [self_weak_ loginWithPhone];
    }];
    
    [[registerBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        LQJSBridgeWebViewCtrl *webViewCtrl = [[LQJSBridgeWebViewCtrl alloc] init];
        webViewCtrl.title = @"注册";
        webViewCtrl.requestURL = [NSString stringWithFormat:@"%@/auth/regist%@", LQWebURL, LQWebPramSuffix];
        [self_weak_.navigationController pushViewController:webViewCtrl animated:YES];
    }];
    
    [[agreeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        LQStaticWebViewCtrl *webViewCtrl = [[LQStaticWebViewCtrl alloc] init];
        webViewCtrl.title = @"服务协议";
        webViewCtrl.requestURL = [NSString stringWithFormat:@"%@/regist/agreement%@", LQWebURL, LQWebPramSuffix];
        [self_weak_.navigationController pushViewController:webViewCtrl animated:YES];
    }];
    
    _tripartiteView.selectedLogin = ^(NSDictionary *channel) { // 三方登录
        if (!agreeImage_weak_.isSelected) {
            [LQJargon hiddenJargon:@"请先阅读用户协议"];
            return ;
        }
        
        LQLoginWayType type = [channel[@"type"] integerValue];
        
        [self_weak_.view showActivityViewWithTitle:nil];
        [[LQLoginManager loginManager] loginWithType:type
                       aParameters:nil
                          callBack:^(BOOL success, NSError *error) {
                              if (success) {
                                  [self_weak_.view hiddenActivityWithTitle:@"登录成功"];
                                  [self_weak_ dismissViewControllerAnimated:YES completion:nil];
                              }else{
                                  if (error && error.code == kLQLoginErrorCodeInstallEnterEnterForeground) {
                                      [self_weak_.view hiddenActivityWithTitle:nil];
                                  }else{
                                      [self_weak_.view hiddenActivityWithTitle:@"登录失败"];
                                  }
                              }
        }];
    };
    // 解决手势界面卡死
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {}

- (void)loginWithPhone
{
    [self.view endEditing:YES];
    if ([NSString validateTel:self.phoneTextField.text] != isRight) { // 校验手机号
        [self.view showActivityViewWithTitle:@"手机号格式不正确"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view hiddenActivity];
        });
        return;
    }
    [self.view showActivityViewWithTitle:@"登录中"];
    
    NSDictionary *parm = @{@"phone": self.phoneTextField.text, @"password" : self.passwordTextField.text};
    
    [[LQLoginManager loginManager] loginWithType:(kLQLoginWayTypePhone)
                   aParameters:parm
                      callBack:^(BOOL success, NSError *error) {
                          if (success) {
                              [self dismissViewControllerAnimated:YES completion:nil];
                              [self.view hiddenActivityWithTitle:@"登录成功"];
                          }else{
                              [self.view hiddenActivityWithTitle:@"登录失败"];
                          }
    }];
}

@end
