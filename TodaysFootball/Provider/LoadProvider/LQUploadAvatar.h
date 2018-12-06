//
//  LQUploadAvatar.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"

/**
 单图上传
 */
@interface LQUploadAvatarReq : LQHttpRequest

@property (nonatomic, strong) NSData *imageData;

@end

@interface LQUploadAvatarRes : LQNetResponse

@property (nonatomic, copy) NSString * avatarUrl;


@end
