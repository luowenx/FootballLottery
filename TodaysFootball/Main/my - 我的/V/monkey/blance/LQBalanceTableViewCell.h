//
//  LQBalanceTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQBalanceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (nonatomic, strong) UILabel * typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
