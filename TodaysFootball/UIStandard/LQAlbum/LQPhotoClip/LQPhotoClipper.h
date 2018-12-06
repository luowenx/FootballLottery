//
//  LQPhotoClipper.h
//  ChunK
//
//  Created by nevsee on 16/9/29.
//  Copyright © 2016年 haochang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 图片裁剪页
@interface LQPhotoClipper : UIViewController
@property (nonatomic) BOOL showNavigationBarWhenDisappear;
@property (nonatomic) CGSize imageSize; // 图片大小
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, copy, nullable) void (^chooseHandle)(UIImage *image);
@property (nonatomic, copy, nullable) void (^uploadHandle)(UIImage * _Nullable image, id value);
@end

NS_ASSUME_NONNULL_END
