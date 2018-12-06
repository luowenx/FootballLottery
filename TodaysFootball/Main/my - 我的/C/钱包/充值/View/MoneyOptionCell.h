//
//  MoneyOptionCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/12.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 价格选择cell
 */
@interface MoneyOptionCell : UICollectionViewCell

/**
 价格
 */
@property (nonatomic, strong) UILabel * priceLabel;

/**
 数量
 */
@property (nonatomic, strong) UILabel * numberLabel;

/**
 优惠角标
 */
@property (nonatomic, strong) UIImageView * cornerView;

@end
