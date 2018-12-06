//
//  LQDetailsTopV.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/23.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 xib 方案详情头部（已修改）
 */
@interface LQDetailsTopV : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *cardL;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *hitStatusBtn;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
