//
//  LQDetailInfomationViewCtrl.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/23.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQDetailInfomationViewCtrl.h"
#import "LQInfoCommsViewCtrl.h"

#import "LQTitleView.h"
#import "LQInputBox.h"

#import "LQInformation.h"
#import "LQOptionManager.h"
#import <UShareUI/UShareUI.h>
#import "LQPostCommReq.h"
#import "AppUtils.h"

@interface LQDetailInfomationViewCtrl ()

@property (nonatomic, strong) LQTitleView * titleView;
@property (nonatomic, strong) LQInputBox * inputView;

@end

@implementation LQDetailInfomationViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self innerUI];
    [self addKeyboardObserver];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(CGFloat)topOffset
{
    return kLQNavANDStatusBarHeight;
}

-(CGFloat)bottomOffset
{
    return 50;
}

- (void)innerUI
{
    self.webView.scrollView.bounces = YES;
    
    _titleView = [LQTitleView newAutoLayoutView];
    _titleView.titleLabel.text = @"资讯";
    [self.view addSubview:_titleView];
    [_titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    _titleView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 32); // size(12, 20)
    
    UIView *rightView = [UIView newAutoLayoutView];
    _titleView.rightView = rightView;
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shareBtn setImage:imageWithName(@"share") forState:UIControlStateNormal];
    [rightView addSubview:shareBtn];
    [shareBtn autoSetDimensionsToSize:CGSizeMake(44, kLQNavHeight)];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightBtn setImage:imageWithName(@"collected") forState:(UIControlStateSelected)];
    [rightBtn setImage:imageWithName(@"collection") forState:(UIControlStateNormal)];
    [rightView addSubview:rightBtn];
    [rightBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:shareBtn];
    [rightBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shareBtn withOffset:-10];
    [rightBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    RAC(rightBtn, selected) = RACObserve(self, infoObj.isFavorit);
    
    _inputView = [LQInputBox newAutoLayoutView];
    _inputView.placeholder = @"请输入评论内容！";
    [self.view addSubview:_inputView];
    [_inputView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_inputView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    _inputView.bottomCons = [_inputView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];

    @weakify(self)
    [_titleView updateLeftImageName:@"return" handler:^(UIButton *sender) {
        [self_weak_ onBack];
    }];
    
    _inputView.send = ^(NSString *text) {
        @strongify(self)
        
        if (!userManager.isLogin) {
            [LQOptionManager loginMainInTarge:self]; return ;
        }
        
        [self.view showActivityViewWithTitle:@""];
        LQPostCommReq *req = [[LQPostCommReq alloc] init];
        req.docId = self.infoObj.docId;
        req.content = text;
        [req requestWithCompletion:^(id response) {
            [self.view hiddenActivity];
        } error:^(id error) {
            [self.view hiddenActivityWithTitle:@"发表失败"];
        }];
    };
    
    _inputView.comment = ^{
        LQInfoCommsViewCtrl *infoCommsViewCtrl = [[LQInfoCommsViewCtrl alloc] init];
        infoCommsViewCtrl.info = self_weak_.infoObj;
        [self_weak_.navigationController pushViewController:infoCommsViewCtrl animated:YES];
    };
    
    
    [[rightBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self)
        
        if (!userManager.isLogin) {
            [LQOptionManager loginMainInTarge:self]; return ;
        }
        
        [self.view showActivityViewWithTitle:@""];
        [LQOptionManager infomationisFavorite:self.infoObj.isFavorit
                                        docId:self.infoObj.docId
                                     callBack:^(BOOL success, NSError *error) {
                                         if (success) {
                                             [self.view hiddenActivityWithTitle:@"操作成功"];
                                             self.infoObj.isFavorit = !self.infoObj.isFavorit;
                                         }else{
                                             [self.view hiddenActivityWithTitle:@"操作失败"];
                                         }
                                     }];
    }];

    [[shareBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
            NSString *title = [AppUtils bundleName];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                                     descr:self_weak_.infoObj.title
                                                                                 thumImage:self_weak_.infoObj.coverImg];
            shareObject.webpageUrl = self_weak_.infoObj.url;
            messageObj.shareObject = shareObject;

            [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                messageObject:messageObj
                                        currentViewController:self_weak_
                                                   completion:^(id result, NSError *error) {
                                                       if (error) {
                                                           UMSocialLogInfo(@"************Share fail with error %@*********",error);
                                                       }else {
                                                           if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                               UMSocialShareResponse *resp = result;
                                                               //分享结果消息
                                                               UMSocialLogInfo(@"response message is %@",resp.message);
                                                               //第三方原始返回的数据
                                                               UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                                           }else{
                                                               UMSocialLogInfo(@"response data is %@",result);
                                                           }
                                                       }
                                                   }];
        }];
    }];
}



- (void)dealloc
{
    NSLog(@"%@ did dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addKeyboardObserver
{
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.inputView annimationWithKeyboardFrame:keyboardFrame];
    
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    [self.inputView hiddenBox];
}



@end
