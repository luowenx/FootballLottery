//
//  LQMyTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMyTableViewCell.h"
#import "LQBalanceVC.h"
#import "LQRechargeVC.h"
#import "LQSetupVC.h"
#import "LQAppConfiger.h"

@implementation LQMyTableViewCell

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
        [setContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:is_iPhoneX?40:20];
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
        
        _avatarImageView = [UIImageView newAutoLayoutView];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView roundedRectWith:29];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView autoSetDimensionsToSize:CGSizeMake(58, 58)];
        [_avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18.5];
        [_avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:32.5];
        
        UIView *userContenView = [UIView newAutoLayoutView];
        [self.contentView addSubview:userContenView];
        [userContenView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarImageView withOffset:17.5];
        [userContenView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_avatarImageView];
        
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.font = [UIFont lqsFontOfSize:38];
        nameLabel.textColor = [UIColor whiteColor];
        [userContenView addSubview:nameLabel];
        [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        NSLayoutConstraint *nameCon = [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];
        _nameLabel = nameLabel;
        
        UIImageView *beanImageView = [UIImageView newAutoLayoutView];
        beanImageView.image = imageWithName(@"彩豆色块");
        beanImageView.userInteractionEnabled = YES;
        [userContenView addSubview:beanImageView];
        [beanImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [beanImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [beanImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLabel withOffset:2];
        [beanImageView autoSetDimensionsToSize:CGSizeMake(80, 21)];
        [beanImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:(NSLayoutRelationGreaterThanOrEqual)];

        UIImageView *beanImage = [UIImageView newAutoLayoutView];
        beanImage.image = imageWithName(@"白彩豆图标");
        [beanImageView addSubview:beanImage];
        [beanImage autoSetDimensionsToSize:CGSizeMake(9, 9)];
        [beanImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [beanImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        
        UILabel *bean = [UILabel newAutoLayoutView];
        bean.text = @"乐豆";
        bean.textColor = [UIColor whiteColor];
        bean.font = [UIFont lqsFontOfSize:18];
        [beanImageView addSubview:bean];
        [bean autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [bean autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:beanImage withOffset:-2];
        [NSLayoutConstraint autoSetPriority:(UILayoutPriorityRequired + 1) forConstraints:^{
            [bean autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            [bean autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
        }];
        
        UILabel *beanLabel = [UILabel newAutoLayoutView];
        beanLabel.textColor = [UIColor whiteColor];
        beanLabel.textAlignment = NSTextAlignmentCenter;
        beanLabel.font = [UIFont lqsFontOfSize:26 isBold:YES];
        [beanImageView addSubview:beanLabel];
        [beanLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [beanLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [beanLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:bean];
        _beanLabel = beanLabel;

        @weakify(self)
        [[setContentView rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.setting ?self_weak_.setting():nil;
        }];
        
        [[rechargeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            self_weak_.recharge?self_weak_.recharge():nil;
        }];
        
        [beanImageView addTapGestureWithBlock:^(UIView *gestureView) {
            self_weak_.balance?self_weak_.balance():nil;
        }];
        
        @weakify(nameCon)
        RAC(beanImageView, hidden) = [RACObserve(LQAppConfiger.shareInstance, appStatus) map:^id(id value) {
            if ([value boolValue]) {
                nameCon_weak_.constant = 0;
            }else{
                nameCon_weak_.constant = 20;
            }
            return @(![value boolValue]);
        }];
        
        RAC(rechargeBtn, hidden) = [RACObserve(LQAppConfiger.shareInstance, appStatus) map:^id(id value) {
            return @(![value boolValue]);
        }];
    }
    return self;
}

@end
