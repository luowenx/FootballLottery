//
//  SettingManager.h
//  haochang
//
//  Created by JinpanXiang on 15-2-3.
//  Copyright (c) 2015年 Administrator. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AuthorizationType) {
    //  AuthorizationTypeLocation = 0, //位置
    AuthorizationTypeCamera,//相机
    AuthorizationTypePhoto,//相册
    AuthorizationTypeRecord,//麦克风
    AuthorizationTypeRessBook,//电话薄
    AuthorizationTypeLocation,//定位
};

typedef void(^ AuthorizationSuccessBlock)(AuthorizationType type,BOOL result);//ios7 8 可以检测  ios6直接返回成功
typedef void(^ AuthorizationFaileBlock)(AuthorizationType type);//不可能发生！

@interface AuthorizationManager : NSObject

//特殊处理，有时在获取通讯录权限时，不需要弹出提示框
@property (nonatomic, assign) BOOL hiddenAddressBookAlert;

+ (instancetype)shareManager;

- (void)authorizationWithType:(AuthorizationType)type success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile;
- (void)authorizationWithType:(AuthorizationType)type showMsg:(NSString *)showMsg success:(AuthorizationSuccessBlock)success faile:(AuthorizationFaileBlock)faile;

@end
