//
//  PostViewController.h
//  haochang
//
//  Created by liusenlin on 14-6-27.
//  Copyright (c) 2014年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  相机--照片预览（拍完照片进入该界面）
 */
@interface PostViewController : UIViewController

//当前照片
@property (nonatomic,strong) UIImage *postImage;
@property (nonatomic, copy) MCBlockParam completeBlock;

@end
