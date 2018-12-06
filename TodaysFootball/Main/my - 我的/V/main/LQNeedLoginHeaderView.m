//
//  LQNeedLoginHeaderView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQNeedLoginHeaderView.h"

@implementation LQNeedLoginHeaderView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *bgView = [UIImageView newAutoLayoutView];
        bgView.image = imageWithName(@"redbg");
        [self.contentView addSubview:bgView];
        [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        UIButton *setContentView = [UIButton newAutoLayoutView];
        [setContentView setImage:imageWithName(@"set") forState:(UIControlStateNormal)];
        [self.contentView addSubview:setContentView];
        [setContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:is_iPhoneX?40: 20];
        [setContentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8];
        [setContentView autoSetDimensionsToSize:CGSizeMake(44, 44)];
        
        UIButton *rechargeBtn = [UIButton newAutoLayoutView];
        [rechargeBtn borderWidth:1 color:[UIColor whiteColor]];
        [rechargeBtn roundedRectWith:4];
        rechargeBtn.titleLabel.font = [UIFont lqsFontOfSize:30];
        UIImage *rechargeImag = imageWithName(@"充值箭头");
        [rechargeBtn setTitle:@"充值" forState:(UIControlStateNormal)];
        [rechargeBtn setImage:rechargeImag forState:(UIControlStateNormal)];
        [rechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -rechargeImag.size.width, 0, rechargeImag.size.width)];
        [rechargeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, rechargeBtn.titleLabel.font.pointSize*2 + 5, 0, - rechargeBtn.titleLabel.font.pointSize*2)];

        [self.contentView addSubview:rechargeBtn];
        [rechargeBtn autoSetDimensionsToSize:CGSizeMake(64, 27)];
        [rechargeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [rechargeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:setContentView withOffset:22.5];
        
        UIButton *headBtn = [UIButton newAutoLayoutView];
        [headBtn setImage:LQPlaceholderIcon forState:(UIControlStateNormal)];
        [headBtn roundedRectWith:30];
        headBtn.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:headBtn];
        [headBtn autoSetDimensionsToSize:CGSizeMake(58, 58)];
        [headBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18.5];
        [headBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:32.5];
        
        UIView *loginContenView = [UIView newAutoLayoutView];
        [self.contentView addSubview:loginContenView];
        [loginContenView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headBtn withOffset:17.5];
        [loginContenView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headBtn];
        
        UIButton *phoneLoginBtn = [UIButton newAutoLayoutView];
        phoneLoginBtn.titleLabel.font = [UIFont lqsFontOfSize:38];
        [phoneLoginBtn setTitle:@"登录/注册 >" forState:(UIControlStateNormal)];
        [loginContenView addSubview:phoneLoginBtn];
        [phoneLoginBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [phoneLoginBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [phoneLoginBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        
        UIButton *weChatBtn = [UIButton newAutoLayoutView];
        [weChatBtn setTitle:@"微信" forState:(UIControlStateNormal)];
        [weChatBtn setImage:imageWithName(@"微信") forState:(UIControlStateNormal)];
        weChatBtn.titleLabel.font = [UIFont lqsFontOfSize:32];
        [loginContenView addSubview:weChatBtn];
        [weChatBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [weChatBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [weChatBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneLoginBtn withOffset:10];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:weChatBtn withOffset:10];
        [line autoSetDimensionsToSize:CGSizeMake(1, 12.5)];
        [line autoAlignAxis:ALAxisHorizontal toSameAxisOfView:weChatBtn];
        
        UIButton *qqBtn = [UIButton newAutoLayoutView];
        qqBtn.titleLabel.font = [UIFont lqsFontOfSize:32];
        [qqBtn setImage:imageWithName(@"QQ") forState:(UIControlStateNormal)];
        [qqBtn setTitle:@"QQ" forState:(UIControlStateNormal)];
        [self.contentView addSubview:qqBtn];
        [qqBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:weChatBtn];
        [qqBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line withOffset:10];
        
        @weakify(self)
        [[phoneLoginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.login?self_weak_.login(kLQLoginWayTypePhone):nil;
        }];
        
        [[headBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.login?self_weak_.login(kLQLoginWayTypePhone):nil;
        }];
       
        [[weChatBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.login?self_weak_.login(kLQLoginWayTypeWX):nil;
        }];
        
        [[qqBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.login?self_weak_.login(kLQLoginWayTypeQQ):nil;
        }];
        
        [[setContentView rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.setting ?self_weak_.setting():nil;
        }];
        
        [[rechargeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.recharge?self_weak_.recharge():nil;
        }];
        
        RAC(rechargeBtn, hidden) = [RACObserve(LQAppConfiger.shareInstance, appStatus) map:^id(id value) {
            return @(![value boolValue]);
        }];
    }
    return self;
}

@end
