//
//  LQRecommendView.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 专家-- 推荐
 */
@interface LQRecommendView : UIView

@property (nonatomic, strong, readonly) UICollectionView * collectionView;

@property (nonatomic, strong) NSArray *dataArray;
// 设置标题
@property (nonatomic, copy) NSString * (^title)(id dataObj) ;
// 设置图片
@property (nonatomic, copy) void (^setImage)(id dataObj, __weak LQAvatarView *imageView);

@property (nonatomic, copy) void (^selected)(id dataObj);


@end
