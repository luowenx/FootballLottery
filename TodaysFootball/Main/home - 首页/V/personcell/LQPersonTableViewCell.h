//
//  LQPersonTableViewCell.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/22.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonCellActionType) {
    kPersonCellActionBack, // 页面返回
    kPersonCellActionShare, // 分享
};

/**
 专家信息
 */
@class LQMatchTagView;
@interface LQPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *PosPerL;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *fansL;
@property (weak, nonatomic) IBOutlet UILabel *desL;
@property (weak, nonatomic) IBOutlet UILabel *hitL;
@property (weak, nonatomic) IBOutlet UILabel *hitDeL;
@property (weak, nonatomic) IBOutlet UILabel *hitNowL;
@property (weak, nonatomic) IBOutlet UILabel *hitDelNowL;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *hitRateTip;
@property (weak, nonatomic) IBOutlet UILabel *nearWinTip;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (nonatomic, strong) UITextView * briefTextView;

/**
 绑定数据对象
 */
@property (nonatomic) id  dataObj;

/**
 事件回调
 */
@property (nonatomic, copy) void (^personCellAction)(PersonCellActionType type);

/**
 关注
 */
@property (nonatomic, copy) void (^follow)(UIButton *sender);

/**
 详情连接
 */
@property (nonatomic, copy) void (^descLink)(id dataObj);

@end
