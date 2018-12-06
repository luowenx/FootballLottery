//
//  SCCaptureCameraController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "SCCaptureSessionManager.h"

/**
 *  相机
 */
@interface SCCaptureCameraController : UIViewController

//照片预览尺寸
@property (nonatomic, assign) CGRect previewRect;
//是否在显示照片前隐藏stutabar
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;

@property (nonatomic, copy) MCBlockParam completeBlock;

@end
