//
//  LQUploadAvatar.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/1/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import "LQUploadAvatar.h"
#import "AFHTTPSessionManager.h"
#import "LQAppConfiger.h"
@implementation LQUploadAvatarReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/users/avatar";
    }
    return self;
}

-(void)requestWithCompletion:(HTTPSuccessBlock)completionBlock error:(HTTPErrorBlock)errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    if (!userManager.authorizeToken) {// token 没有
        [[LQAppConfiger shareInstance] forceBoot];
    }
    [manager.requestSerializer setValue:userManager.authorizeToken forHTTPHeaderField:@"x-lw-app"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"image/jpeg", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",lqUrl, self.relativeUrl]
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        
        [formData appendPartWithFileData:self.imageData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"]; //
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        //            NSLog(@"progress is %@",uploadProgress);
        //        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        LQNetResponse * res = [self httpResponseParserData:(NSDictionary *)responseObject];
        
        if (res.ret == kLQNetResponseTKOverdue) { // token 过期
            [[LQAppConfiger shareInstance] getRegisterToken];
        }else if (res.ret == kLQNetResponseNeedLogin){  // 需要登录
            [userManager logOut];
        }
        completionBlock?completionBlock(res):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock?errorBlock(error):nil;
    }];
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQUploadAvatarRes *res = [[LQUploadAvatarRes alloc] initWith:(NSDictionary *)aData];
    startParser(res.data, res, LQUploadAvatarRes)
    parserObjAttr(avatarUrl)
    return res;
}

@end


@implementation LQUploadAvatarRes

@end
