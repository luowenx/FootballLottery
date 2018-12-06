//
//  LQPhotoClipper.m
//  ChunK
//
//  Created by nevsee on 16/9/29.
//  Copyright © 2016年 haochang. All rights reserved.
//

#import "LQPhotoClipper.h"
#import "LQUploadAvatar.h"

@interface LQPhotoClipper () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LQPhotoClipper

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _showNavigationBarWhenDisappear = YES;
        [self setUserInterface];
        [self setNavigationItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_showNavigationBarWhenDisappear) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)setNavigationItem {
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kLQStatusBarHeight, CGRectGetWidth(self.view.bounds), kLQNavHeight)];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(cancelAction)];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(chooseAction)];
    navBar.items = @[navigationItem];
}

- (void)setUserInterface {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    // 添加遮蔽图层
    CGFloat maskLayerHeight = (CGRectGetHeight(self.view.bounds) - CGRectGetWidth(self.view.bounds)) / 2;
    CGFloat maskLayerWidth = CGRectGetWidth(self.view.bounds);
    UIView *topMaskLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maskLayerWidth, maskLayerHeight)];
    topMaskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:topMaskLayer];
    
    CGFloat bottomY = CGRectGetHeight(self.view.bounds) - maskLayerHeight;
    UIView *bottomMaskLayer = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, maskLayerWidth, maskLayerHeight)];
    bottomMaskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:bottomMaskLayer];
    
    CGFloat lineHeight = 0.5;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, maskLayerHeight, maskLayerWidth, lineHeight)];
    topLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, maskLayerHeight, lineHeight,  maskLayerWidth)];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY - lineHeight, maskLayerWidth, lineHeight)];
    bottomLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(maskLayerWidth - lineHeight, maskLayerHeight, lineHeight, maskLayerWidth)];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightLine];
}

#pragma mark - event response
- (void)cancelAction {
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)chooseAction {
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;

    CGPoint point = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y + (screenH - screenW) / 2);
    
    CGRect imageRect = CGRectMake(point.x * (_originalImage.size.width  / _imageView.frame.size.width),
                                  point.y * (_originalImage.size.height / _imageView.frame.size.height),
                                  screenW * (_originalImage.size.width  / _imageView.frame.size.width),
                                  screenW * (_originalImage.size.height / _imageView.frame.size.height));
    
    UIImage *clipImage = [self clipImage:_imageView.image rect:imageRect];
    
    if (!CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        clipImage = [self image:clipImage resizeToSize:_imageSize];
    }
    
    if (_chooseHandle) _chooseHandle(clipImage);
    
    [self uploadPortrait:clipImage];
}

#pragma mark - request
// 上传头像
- (void)uploadPortrait:(UIImage *)portrait {
    if (!portrait) [self.view showActivityViewWithTitle:(@"提交失败")];
    
    [self.view showActivityViewWithTitle:nil];
    portrait = [portrait imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
    // 压缩图片
    NSData *imageData = [portrait compressedDataToSize:200.f];
    LQUploadAvatarReq *req = [[LQUploadAvatarReq alloc] init];
    req.imageData = imageData;
    [req requestWithCompletion:^(id response) {
        LQUploadAvatarRes * res = (LQUploadAvatarRes*)response;
        if (res.ret == kLQNetResponseSuccess) {
            [self.view hiddenActivityWithTitle:nil];
            if (_uploadHandle) _uploadHandle([UIImage imageWithData:imageData], res);
        }else{
            [self.view hiddenActivityWithTitle:@"提交失败"];
        }
    } error:^(id error) {
        [self.view hiddenActivityWithTitle:@"提交失败"];
    }];
}

#pragma mark - private method
// 裁剪图片
- (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect {
    rect.origin.x *= image.scale;
    rect.origin.y *= image.scale;
    rect.size.width *= image.scale;
    rect.size.height *= image.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return [UIImage new];
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *clipImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return clipImage;
}

- (UIImage *)image:(UIImage *)image resizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

#pragma mark - request

#pragma mark - getter and setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.clipsToBounds = YES;
            view;
        });
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            view.showsHorizontalScrollIndicator = NO;
            view.showsVerticalScrollIndicator = NO;
            view.bounces = YES;
            view.delegate = self;
            view.minimumZoomScale = 1.0;
            view.maximumZoomScale = 3.0;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _scrollView;
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    
    // 判断宽高
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageH = originalImage.size.height;
    CGFloat imageW = originalImage.size.width;
    CGFloat scale = imageW / imageH;
    CGSize disPlaySize;
    
    if (isnan(scale)) return;
    if (scale > 1) {
        disPlaySize = CGSizeMake(imageW * (screenW / imageH), screenW);
    } else {
        disPlaySize = CGSizeMake(screenW, imageH * (screenW / imageW));
    }
    if (isnan(disPlaySize.width)) {
        disPlaySize.width = 0;
    }
    if (isnan(disPlaySize.height)) {
        disPlaySize.height = 0;
    }
    
    // 布局
    _imageView.frame = CGRectMake(0, 0, disPlaySize.width, disPlaySize.height);
    _imageView.image = originalImage;
    
    _scrollView.contentSize  = _imageView.frame.size;
    _scrollView.contentInset = UIEdgeInsetsMake((screenH - screenW) / 2, 0, (screenH - screenW) / 2, 0);

    if (scale > 1) {
        _scrollView.contentOffset = CGPointMake((disPlaySize.width - screenW) / 2 , _scrollView.contentOffset.y);
    } else {
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, (disPlaySize.height - screenH) / 2);
    }
}

@end
