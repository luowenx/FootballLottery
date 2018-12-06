//
//  PostViewController.m
//  haochang
//
//  Created by liusenlin on 14-6-27.
//  Copyright (c) 2014年 Administrator. All rights reserved.
//

#import "PostViewController.h"
#import "LQPhotoClipper.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
    
     NSLog(@"_transImage:%@", [NSValue valueWithCGSize:_postImage.size]);
    
    
    if (_postImage) {
        UIImageView *imgView  = [[UIImageView alloc] initWithImage:_postImage];
        imgView.clipsToBounds = YES;
        imgView.contentMode   = UIViewContentModeScaleAspectFill;
        imgView.frame         = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        CGPoint Viewpoint     = self.view.center;
        Viewpoint.y = IOS7_OR_LATER ? Viewpoint.y-17 : Viewpoint.y-27;
        
        imgView.center  = Viewpoint;
        [self.view addSubview:imgView];
    }
    
    UIButton *RepeatBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, self.view.frame.size.height - 90, 40, 40)];
    if (IOS7_OR_LATER)
    {
        if (UIDeviceScreenHeight < 500)
        {
            RepeatBtn.frame = CGRectMake(26, self.view.frame.size.height - 80, 40, 40);
        }
    }
    else
    {
        if (UIDeviceScreenHeight < 500)
        {
            RepeatBtn.frame = CGRectMake(26, self.view.frame.size.height - 55, 40, 40);
        }
    }
    [RepeatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RepeatBtn setTitle:(@"重拍") forState:UIControlStateNormal];
    RepeatBtn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
    [RepeatBtn addTarget:self action:@selector(RepeatBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RepeatBtn];
    
    UIButton * OkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OkBtn.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width-90)/2, self.view.frame.size.height - 110, 90, 90);
    if (IOS7_OR_LATER)
    {
        if (UIDeviceScreenHeight < 500)
        {
            OkBtn.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width-90)/2, self.view.frame.size.height - 95, 90, 90);
        }
    }
    else
    {
        if (UIDeviceScreenHeight < 500)
        {
            OkBtn.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width-90)/2, self.view.frame.size.height - 81, 90, 90);
        }

    }
    [OkBtn setImage:imageWithName(@"SCCamera.bundle/find_friends_photo_finish") forState:UIControlStateNormal];
    OkBtn.tag = 2002;
    [OkBtn addTarget:self action:@selector(OkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OkBtn];
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
 {
     UIGraphicsBeginImageContext(size);
     [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
     UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return scaledImage;
 }

#pragma mark 重拍
-(void)RepeatBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 完成
- (void)OkBtnPressed:(UIButton *)sender
{
    if (_postImage) {
        LQPhotoClipper *clipper = [[LQPhotoClipper alloc] init];
        clipper.showNavigationBarWhenDisappear = NO;
        clipper.originalImage = _postImage;
        clipper.imageSize = CGSizeMake(800, 800);
        clipper.uploadHandle = ^(UIImage *image, id res) {
            if (self.completeBlock) self.completeBlock(@{@"image": image, @"res": res});
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        [self.navigationController pushViewController:clipper animated:YES];
    }
}

@end
