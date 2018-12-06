//
//  SCCaptureCameraController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCaptureCameraController.h"
#import "SCSlider.h"
#import "SCNavigationController.h"
#import "MBProgressHUD.h"

#define kNotificationOrientationChange          @"kNotificationOrientationChange"
#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      0   //对焦框是否一直闪到对焦完成
#define SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA   1   //没有拍照功能的设备，是否给一张默认图片体验一下
//height
#define CAMERA_TOPVIEW_HEIGHT   44  //title
#define CAMERA_MENU_VIEW_HEIGH  44  //menu
//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f
// 是否iPad
#define isPad_SC (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)//设备类型改为Universal才能生效
#define isPad_AllTargetMode_SC ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)//设备类型为任何类型都能生效
//iPhone5及以上设备，按钮的位置放在下面。iPhone5以下的按钮放上面。
#define isHigherThaniPhone4_SC ((isPad_AllTargetMode_SC && [[UIScreen mainScreen] applicationFrame].size.height <= 960 ? NO : ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height > 960 ? YES : NO) : NO)))

//顶部按钮类型 取消 翻转 闪光灯
#define CAMERACANCLE     1001
#define CAMERATURN       1002
#define CAMERAFLASHLIGHT 1003

@interface SCCaptureCameraController () {
    int alphaTimes;
    CGPoint currTouchPoint;
}

@property (nonatomic, strong) SCCaptureSessionManager * captureManager;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) UIView *topContainerView;//顶部view
@property (nonatomic, strong) UIView *bottomContainerView;//除了顶部标题、拍照区域剩下的所有区域
@property (nonatomic, strong) UIView *cameraMenuView;//闪光灯、前后摄像头等按钮
@property (nonatomic, strong) NSMutableSet *cameraBtnSet;
@property (nonatomic, strong) UIView *doneCameraUpView;
@property (nonatomic, strong) UIView *doneCameraDownView;
//对焦
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) SCSlider *scSlider;

@end

@implementation SCCaptureCameraController

#pragma mark -------------life cycle---------------
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        alphaTimes     = -1;
        currTouchPoint = CGPointZero;
        _cameraBtnSet  = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    
    //navigation bar
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    //status bar
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:kNotificationOrientationChange object:nil];
    
    //session manager
    SCCaptureSessionManager *manager = [[SCCaptureSessionManager alloc] init];
    
    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0, 0, UIDeviceScreenWidth, self.view.frame.size.height);
    }
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    
    [self addTopViewWithText];
    [self addbottomContainerView];
    [self addCameraMenuView];
    [self addFocusView];
    [self addCameraCover];
    [self addPinchGesture];
    [_captureManager.session startRunning];
    
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_hud.label setText:(@"设备不支持拍照功能")];
        [_hud showAnimated:YES];
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (!self.navigationController) {
        if ([UIApplication sharedApplication].statusBarHidden != _isStatusBarHiddenBeforeShowCamera) {
            [[UIApplication sharedApplication] setStatusBarHidden:_isStatusBarHiddenBeforeShowCamera withAnimation:UIStatusBarAnimationSlide];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif
    
    self.captureManager = nil;
}

#pragma mark -------------UI---------------
//顶部视图
- (void)addTopViewWithText
{

    if (!_topContainerView)
    {
        CGFloat topy = self.view.center.y - UIDeviceScreenWidth/2;
        if (IOS7_OR_EARLIER)
        {
            topy = topy-10;
        }
        
        CGFloat hight = topy/2-0.5;
        if (UIDeviceScreenHeight < 500 && IOS7_OR_LATER) {
            hight= hight + 20;
        }
        
        UIView *topview         = [[UIView alloc] initWithFrame:CGRectMake(0, 0,UIDeviceScreenWidth ,hight)];
        topview.backgroundColor = [UIColor blackColor];
        [self.view addSubview:topview];
        self.topContainerView = topview;
        
        UIView *topemptyView         = [[UIView alloc] initWithFrame:CGRectMake(0, hight, UIDeviceScreenWidth, topy/2)];
        topemptyView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:topemptyView];
        
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc] init];
        cancleBtn.frame = CGRectMake(11,IOS7_OR_LATER  ? 20 : 0, 45, 45);
    
        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.tag = CAMERACANCLE;
        [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topview addSubview:cancleBtn];
        
        //摄像头翻转按钮
        UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        turnBtn.frame  = CGRectMake(UIDeviceScreenWidth/2-25,IOS7_OR_LATER? 20 : 0, 50, 45);

        [turnBtn setImage:imageWithName(@"SCCamera.bundle/find_friends_photo_change_camera") forState:UIControlStateNormal];
        turnBtn.tag = CAMERATURN;
        turnBtn.hidden = self.captureManager.isOnlyHasFrontCamera;
        [turnBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topview addSubview:turnBtn];
        
        //闪光灯
        UIButton * lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lightBtn.frame  = CGRectMake(UIDeviceScreenWidth-45, IOS7_OR_LATER  ? 20 : 0, 45, 45);
//        [lightBtn setImage:imageWithName(@"find_friends_photo_light_auto") forState:UIControlStateNormal];
        
        NSString *imgStr = @"";
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        if ([device hasFlash]) {
            switch (device.flashMode) {
                case AVCaptureFlashModeOff: {
                    imgStr = @"SCCamera.bundle/find_friends_photo_light_none";
                    break;
                }
                case AVCaptureFlashModeOn: {
                    imgStr = @"SCCamera.bundle/find_friends_photo_light";
                    break;
                }
                case AVCaptureFlashModeAuto: {
                    imgStr = @"SCCamera.bundle/find_friends_photo_light_auto";
                    break;
                }
            }
            [lightBtn setImage:imageWithName(imgStr) forState:UIControlStateNormal];
        }
        
        lightBtn.tag  =  CAMERAFLASHLIGHT;
        [lightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topview addSubview:lightBtn];
    }
}
#pragma mark 顶部视图点击事件
-(void)btnClicked:(UIButton *)sender{

    switch (sender.tag) {
        case CAMERACANCLE:
            if (self.navigationController) {
                if (self.navigationController.viewControllers.count == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        case CAMERATURN:
            sender.selected = !sender.selected;
            [_captureManager switchCamera:sender.selected];
            break;
        case CAMERAFLASHLIGHT:
            [_captureManager switchFlashMode:sender];
            break;
        default:
            break;
    }
}
//bottomContainerView，总体
- (void)addbottomContainerView
{
    CGFloat buttomy = UIDeviceScreenHeight - self.view.center.y - UIDeviceScreenWidth/2 ;
    UIView * buttomview = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - buttomy, UIDeviceScreenWidth, buttomy)];
    buttomview.backgroundColor = [UIColor blackColor];
    buttomview.userInteractionEnabled = YES;
    [self.view addSubview:buttomview];
    self.bottomContainerView = buttomview;
}

//拍照菜单栏
- (void)addCameraMenuView {
    
    //拍照按钮
    CGFloat cameraBtnLength = 80;
    if (UIDeviceScreenHeight < 500)
    {
        cameraBtnLength = 68;
    }
    [self buildButton:CGRectMake((UIDeviceScreenWidth - cameraBtnLength) / 2,
                                      (_bottomContainerView.frame.size.height - cameraBtnLength) / 2,
                                     cameraBtnLength,
                                     cameraBtnLength)
             normalImgStr:@"SCCamera.bundle/find_friends_photo_take"
          highlightImgStr:@"SCCamera.bundle/find_friends_photo_take"
           selectedImgStr:@""
                   action:@selector(takePictureBtnPressed:)
               parentView:_bottomContainerView];
   
}


- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btn];
    
    return btn;
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:imageWithName(@"SCCamera.bundle/find_friends_photo_focus")];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

//拍完照后的遮罩
- (void)addCameraCover
{
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 0)];
    [self.view addSubview:upView];
    self.doneCameraUpView = upView;
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIDeviceScreenWidth, 0)];
    [self.view addSubview:downView];
    self.doneCameraDownView = downView;
}


//伸缩镜头的手势
- (void)addPinchGesture
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinch];
    //竖向
    CGFloat width = 40;
    CGFloat height = _previewRect.size.height - 100;
    SCSlider *slider = [[SCSlider alloc] initWithFrame:CGRectMake(_previewRect.size.width - width, (_previewRect.size.height + CAMERA_MENU_VIEW_HEIGH - height) / 2+60, width, height-200) direction:SCSliderDirectionVertical];
    slider.alpha = 0.f;
    slider.minValue = MIN_PINCH_SCALE_NUM;
    slider.maxValue = MAX_PINCH_SCALE_NUM;
    WEAKSELF;
    [slider buildDidChangeValueBlock:^(CGFloat value) {
        [weakSelf.captureManager pinchCameraViewWithScalNum:value];
    }];
    [slider buildTouchEndBlock:^(CGFloat value, BOOL isTouchEnd) {
        [weakSelf setSliderAlpha:isTouchEnd];
    }];
    [self.view addSubview:slider];
    self.scSlider = slider;
}

void c_slideAlpha() {
    
}

- (void)setSliderAlpha:(BOOL)isTouchEnd {
    if (_scSlider) {
        _scSlider.isSliding = !isTouchEnd;
        if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
            double delayInSeconds = 3.88;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
                    [UIView animateWithDuration:0.3f animations:^{
                        _scSlider.alpha = 0.f;
                    }];
                }
            });
        }
    }
}

#pragma mark -------------touch to focus---------------
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, currTouchPoint) == NO) {
        return;
    }

    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

#pragma mark -------------点击拍照---------------
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_hud.label setText:(@"设备不支持拍照功能")];
        [_hud showAnimated:YES];
        return;
    }
#endif
    sender.userInteractionEnabled = NO;
    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = self.view.center;//CGPointMake(self.view.center.x, self.view.center.y - CAMERA_TOPVIEW_HEIGHT);
    [actiView startAnimating];
    [self.view addSubview:actiView];
    WEAKSELF;
    [_captureManager takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        });
        [actiView stopAnimating];
        [actiView removeFromSuperview];
         actiView = nil;
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            sender.userInteractionEnabled = YES;
        });
        
       
        NSLog(@"originImage:%@", [NSValue valueWithCGSize:stillImage.size]);
        
        SCNavigationController *nav = (SCNavigationController*)weakSelf.navigationController;
        if ([nav.scNaigationDelegate respondsToSelector:@selector(didTakePicture:image:)]) {
            [nav.scNaigationDelegate didTakePicture:nav image:stillImage];
        } else {
            PostViewController *fc = [[PostViewController alloc] init];
            fc.postImage = stillImage;
            fc.completeBlock = self.completeBlock;
            [nav pushViewController:fc animated:YES];
        }
    }];
}


#pragma mark -------------pinch camera---------------
//伸缩镜头
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    [_captureManager pinchCameraView:gesture];
    if (_scSlider) {
        if (_scSlider.alpha != 1.f) {
            [UIView animateWithDuration:0.3f animations:^{
                _scSlider.alpha = 1.f;
            }];
        }
        [_scSlider setValue:_captureManager.scaleNum shouldCallBack:NO];
        
        if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            [self setSliderAlpha:YES];
        } else {
            [self setSliderAlpha:NO];
        }
    }
}


#pragma mark ------------notification-------------
- (void)orientationDidChange:(NSNotification*)noti {
    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }
        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait://1
            {
                transform = CGAffineTransformMakeRotation(0);
                break;
            }
            case UIDeviceOrientationPortraitUpsideDown://2
            {
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
            }
            case UIDeviceOrientationLandscapeLeft://3
            {
                transform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            }
            case UIDeviceOrientationLandscapeRight://4
            {
                transform = CGAffineTransformMakeRotation(-M_PI_2);
                break;
            }
            default:
                break;
        }
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
        }];
    }];
}

#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationPortrait;
}
#endif

@end
