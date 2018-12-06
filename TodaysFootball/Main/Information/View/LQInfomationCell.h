//
//  LQInfomationCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/20.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 资讯cell
 */
@interface LQInfomationCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * subTitleLabel;

@property (nonatomic, strong) UIImageView * coverImageView;

+ (CGFloat)selfHeight;

@end
