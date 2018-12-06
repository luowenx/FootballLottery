//
//  SCNavigationController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-17.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SCNavigationController;

@protocol SCNavigationControllerDelegate <NSObject>

@optional
- (BOOL)willDismissNavigationController:(SCNavigationController*)navigatonController;
- (void)didTakePicture:(SCNavigationController*)navigationController image:(UIImage*)image;

@end


@interface SCNavigationController : UINavigationController


- (void)showCameraWithParentController:(UIViewController*)parentController;

@property (nonatomic, assign) id <SCNavigationControllerDelegate> scNaigationDelegate;

@property (nonatomic, copy) MCBlockParam completeBlock;//返回为数组image

@end
