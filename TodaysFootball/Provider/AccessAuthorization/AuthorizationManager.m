//
//  SettingManager.m
//  haochang
//
//  Created by JinpanXiang on 15-2-3.
//  Copyright (c) 2015年 Administrator. All rights reserved.
//

#import "AuthorizationManager.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

#import <AddressBook/AddressBook.h>

#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import "AppUtils.h"

#define kSuccessBlock "kSuccessBlock"
#define kAuthorizationType "kAuthorizationType"
#define kFaileBlock  "kFaileBlock"

@interface AuthorizationManager()

@end

@implementation AuthorizationManager

+ (instancetype)shareManager
{
    return [[super alloc] init];
}

- (void)authorizationWithType:(AuthorizationType)type success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile{
    [self authorizationWithType:type showMsg:nil success:success faile:faile];
}

- (void)authorizationWithType:(AuthorizationType)type showMsg:(NSString *)showMsg success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile
{
    //ios8 可以检测 可以跳转
    switch (type) {
        case AuthorizationTypeCamera:
            if (IOS7_OR_LATER) {
                AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                [self processAuthor:type authStatus:authorStatus showMsg:showMsg success:success faile:faile];
            } else if(IOS6_OR_EARLIER){
                //ios6没有摄像头权限设置 直接访问
                if(success)
                    success(type,YES);
            } else {
                if(faile) faile(type);
            }
            break;
        case AuthorizationTypePhoto:
            //ios6有相册权限判断
            if (IOS6_OR_LATER) {
                if (IOS8_OR_LATER) {
                    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
                    [self processAuthor:type authStatus:authorStatus showMsg:showMsg success:success faile:faile];
                } else {
                    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
                    [self processAuthor:type authStatus:authorStatus showMsg:showMsg success:success faile:faile];
                }
            } else {
                if(faile) faile(type);
            }
            break;
        case AuthorizationTypeRecord:
            if (IOS7_OR_LATER) {
                AVAudioSession *avSession = [AVAudioSession sharedInstance];
                
                if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
                    
                    [avSession requestRecordPermission:^(BOOL available) {
                        
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self processAuthor:type authStatus:available?AVAuthorizationStatusAuthorized:AVAuthorizationStatusRestricted showMsg:showMsg success:success faile:faile];
                       });
                    }];

                }
            } else if(IOS6_OR_EARLIER){
                //ios6没有麦克风权限设置 直接访问
                if(success) success(type,YES);
            } else {
                if(faile) faile(type);
            }
            break;
        case AuthorizationTypeRessBook:
            if(IOS6_OR_EARLIER){
                //ios6没有通讯录权限设置 直接访问
                if(success) success(type,YES);
            }else if(@available(iOS 9.0, *)){
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                //未授权
                if (status == CNAuthorizationStatusNotDetermined)
                {
                    CNContactStore *store = [[CNContactStore alloc] init];
                    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (error)
                        {
                            //NSLog(@"未授权");
                            if(!_hiddenAddressBookAlert)
                            {
                                [self processAuthor:type authStatus:ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized showMsg:showMsg success:success faile:faile];
                            }
                            
                        }
                        else
                        {
                            if(success) success(type,YES);
                            //NSLog(@"授权成功");
                        }
                    }];
                }
                //有权限时
                else if (status == CNAuthorizationStatusAuthorized)
                {
                    if(success) success(type,YES);
                }
                //没有权限
                else
                {
                    //NSLog(@"没有权限");
                    if(!_hiddenAddressBookAlert)
                    {
                        [self processAuthor:type authStatus:ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized showMsg:showMsg success:success faile:faile];
                    }
                }
            }
            else if (IOS7_OR_LATER) {
                ABAddressBookRef tmpAddressBook = nil;
                tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(greanted) {
                            if(success) success(type,YES);
                        } else {
                            if(!_hiddenAddressBookAlert)
                            {
                                [self processAuthor:type authStatus:ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized showMsg:showMsg success:success faile:faile];
                            }
                        }
                    });
                });
            }
            else {
                if(faile) faile(type);
            }
            break;
        case AuthorizationTypeLocation:
            if (IOS7_OR_LATER) {
                BOOL isEnabled = [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
                if(!isEnabled) {
                    [self processAuthor:type authStatus:kCLAuthorizationStatusDenied showMsg:showMsg success:success faile:faile];
                }else{
                    if(success) success(type,YES);
                }
            }
            break;
        default:
            break;
    }
}

- (void)processAuthor:(AuthorizationType)type authStatus:(NSInteger)authStatus showMsg:(NSString *)showMsg success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile
{
     //AVAuthorizationStatusRestricted AVAuthorizationStatusDenied
    if (authStatus == 1  || authStatus == 2) {//未授权
        [self showAlertView:type authStatus:authStatus showMsg:showMsg success:success faile:faile];
        return;
    }
    //AVAuthorizationStatusAuthorized
    else if(authStatus == 3){//允许访问
        if(success) success(type,YES);
    }
    //AVAuthorizationStatusNotDetermined
    else if(authStatus == 0){//用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
        
        if (type == AuthorizationTypeCamera) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(success) success(type,granted);
                });
            }];
        } else if (type == AuthorizationTypePhoto) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                //点击“允许”
                if (*stop) {
                    if(success) success(type,YES);
                    return;
                }
                *stop = TRUE;
                
            } failureBlock:^(NSError *error) {
                //点击“不允许”
                if(success) success(type,NO);
            }];
        } else if (type == AuthorizationTypeRessBook) {
        
            if(success) success(type,YES);
        }
    } else {
        if(faile) faile(type);
    }
}

-(void)showAlertView:(AuthorizationType)type authStatus:(NSInteger)authStatus showMsg:(NSString *)showMsg success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile{
    NSString *title = nil;
    NSString *message = nil;
    NSString *otherButtonTitles = (@"设置");
    NSString *appName = [AppUtils bundleName];
    switch (type) {
        case AuthorizationTypeCamera: {
            if (IOS8_OR_LATER) {
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的相机，请先到【设置】进行授权", appName];
            } else {
                title = (@"无法使用相机");
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的相机，请在【设置-隐私-相机】中进行设置", appName];
            }
            
        }
            break;
        case AuthorizationTypePhoto: {
            if (IOS8_OR_LATER) {
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的相册，请先到【设置】进行授权", appName];
            } else {
                title =  (@"无法使用相册");
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的相册，请在【设置-隐私-照片】中进行设置", appName];
            }
            
        }
            break;
        case AuthorizationTypeRecord:{
            if (IOS8_OR_LATER) {
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的麦克风，请先到【设置】进行授权", appName];
            } else {
                title = (@"无法使用麦克风");
                message = [NSString stringWithFormat:@"“%@”还没有权限访问您的麦克风，请在【设置-隐私-麦克风】中进行设置", appName];
            }
        }
            break;
        case AuthorizationTypeRessBook:{
            
            title = (@"无法访问通讯录");
            message = (@"开启通讯录仅限用于查看你的好友");
            otherButtonTitles = (@"去开启");
        }
            break;
        case AuthorizationTypeLocation:{
            if (IOS8_OR_LATER) {
                message = [NSString stringWithFormat:@"“%@”无法获取您的位置，请在【设置】进行授权", appName];
            } else {
                title = (@"无法使用位置");
                message = [NSString stringWithFormat:@"“%@”无法获取您的位置，请在【设置-隐私-定位服务】中进行设置", appName];
            }
        }
            break;
        default:
            break;
    }
    
    message = showMsg.length > 0 ? showMsg : message;
    
    if (message.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction*cancelAction  = [UIAlertAction actionWithTitle:IOS8_OR_LATER  ? (@"取消") : (@"确定")
                                                                   style:(UIAlertActionStyleCancel)
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     if (success) success(type,NO);
                                                                 }];
            [alertController addAction:cancelAction];
            
            if (@available(iOS 9.0, *)) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitles
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                      }];
                [alertController addAction:otherAction];
                
                alertController.preferredAction = alertController.actions.lastObject;
            }

            [UIViewController.topViewController_ presentViewController:alertController animated:YES completion:nil];
        });
    }
}



@end
