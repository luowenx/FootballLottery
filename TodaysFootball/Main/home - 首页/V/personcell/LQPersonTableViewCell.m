//
//  LQPersonTableViewCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPersonTableViewCell.h"

@interface LQPersonTableViewCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTopCons;

@property (weak, nonatomic) IBOutlet UIImageView *redBgView;

@end

@implementation LQPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backTopCons.constant += is_iPhoneX?10:0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.centerLine.backgroundColor = [UIColor flsSpaceLineColor];

    [self.headIma setCornerRadius:29 borderColor:UIColorFromRGB(0xb2b2b2) borderWidth:1];
    self.nameL.font = [UIFont lqsFontOfSize:38];
    self.PosPerL.font = [UIFont lqsFontOfSize:22];
    
    [self.followBtn setCornerRadius:3 borderColor:[UIColor whiteColor] borderWidth:1];
    self.followBtn.titleLabel.font  = [UIFont lqsFontOfSize:28];
    [self.followBtn setTitle:@"+  关注" forState:(UIControlStateNormal)];
    [self.followBtn setTitle:@"已关注" forState:(UIControlStateSelected)];

    self.desL.textColor = UIColorFromRGB(0xa2a2a2);
    self.desL.font = [UIFont lqsFontOfSize:24];
    self.hitL.font = [UIFont lqsBEBASFontOfSize:68];
    self.hitNowL.font = [UIFont lqsBEBASFontOfSize:68];

    self.hitDeL.font = [UIFont lqsFontOfSize:18];
    self.hitDelNowL.font = [UIFont lqsFontOfSize:18];
    self.hitDeL.textColor = UIColorFromRGB(0xbcbcbc);
    self.hitDelNowL.textColor = UIColorFromRGB(0xbcbcbc);
    
    self.nearWinTip.font =[UIFont lqsFontOfSize:28];
    self.hitRateTip.font = [UIFont lqsFontOfSize:28];
    self.hitRateTip.textColor = [UIColor flsMainColor];
    self.nearWinTip.textColor = [UIColor flsMainColor];
    
    self.briefTextView = [UITextView newAutoLayoutView];
    self.briefTextView.scrollEnabled = NO;
    self.briefTextView.delegate = self;
    self.briefTextView.font = self.desL.font;
    self.briefTextView.textColor = self.desL.textColor;
    self.briefTextView.editable = NO;
    self.desL.hidden = YES;
    // 可修改超链文本颜色
    self.briefTextView.tintColor = [UIColor flsMainColor2];
    [self.contentView addSubview:self.briefTextView];
    [self.briefTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    [self.briefTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
    [self.briefTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.redView withOffset:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followBtn:(UIButton *)sender {
    self.follow?self.follow(sender):nil;
}

- (IBAction)shareBtn:(UIButton *)sender{
    self.personCellAction?self.personCellAction(kPersonCellActionShare):nil;
}

- (IBAction)backBtn:(UIButton *)sender {
    self.personCellAction?self.personCellAction(kPersonCellActionBack):nil;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    self.descLink?self.descLink(self.dataObj):nil;
    return NO;
}


@end
