//
//  LQAppConfiger.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQAppConfiger.h"
#import "LQAppInitReq.h"
#import "LQTokenRegster.h"
#import "LQVersionsReq.h"
#import "AppUtils.h"

@interface  LQAppConfiger()<LQEncode>
// 第一次登录，可以优化---比如放在启动也调接口
@property (nonatomic) BOOL isFistInit;

@property (nonatomic, strong) LQVersionObj * versionObj;

@end

static LQAppConfiger *_shareInstance = nil;
@implementation LQAppConfiger

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[LQAppConfiger alloc] init];
        _shareInstance.appStatus = NO;   // 默认为审核状态
        NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:kLQPathWithAppConfiger];
        [_shareInstance configureWithDic:infoDic];
    });
    return _shareInstance;
}

- (void)configureWithDic:(NSDictionary*)localDic
{
    if (localDic.count == 0) {
        return;
    }
    startParser(localDic, self, LQAppConfiger)
    parserBaseAttr(isFistInit, boolValue)
    parserBaseAttr(appStatus, boolValue)
    
    self.versionObj = [[LQVersionObj alloc] initWith:localDic[@"versionObj"]];
}


- (BOOL)saveConfiger
{
    NSDictionary *userDic = self.toJSON;
    if (userDic.count == 0) {
        return NO;
    }
    return [userDic writeToFile:kLQPathWithAppConfiger atomically:YES];
}


- (BOOL)deleteConfiger
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kLQPathWithAppConfiger]) {
        return [[NSFileManager defaultManager] removeItemAtPath:kLQPathWithAppConfiger error:NULL];
    }
    return NO;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@(self.appStatus) forKey:@"appStatus"];
    [dic setValue:@(self.isFistInit) forKey:@"isFistInit"];
    
    if (self.versionObj) {
        [dic setValue:self.versionObj.toJSON forKey:@"versionObj"];
    }
    
    return dic.copy;
}

#pragma mark ===  public

-(void)forceBoot
{
    [LQAppConfiger shareInstance].isFistInit = NO;
    [self boot];
}

-(void)boot
{
    if ([LQAppConfiger shareInstance].isFistInit) {
        return;
    }
    LQAppInitReq *req = [[LQAppInitReq alloc] init];
    req.t =[[NSDate date] timeIntervalSince1970];
    req.a = kLQAPPKEY;
    NSString *s = [NSString stringWithFormat:@"%@%@", req.a ,@(req.t)];
    req.s = [[s  stringMD5] lowercaseString];
    [req requestWithCompletion:^(id response) {
        LQAppInitRes *res  = (LQAppInitRes *)response;
        if (res.ret == 0) {
            userManager.authorizeToken = res.tk;
            userManager.restrictToken = res.rk;
            [userManager saveCurrentUser];
            
            [LQAppConfiger shareInstance].isFistInit = YES;
            [[LQAppConfiger shareInstance] saveConfiger];
        }
    } error:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LQAppConfiger shareInstance] boot];
        });
    }];
}

-(void)getRegisterToken
{
    LQTokenRegsterReq *req = [[LQTokenRegsterReq alloc] init];
    req.t =[[NSDate date] timeIntervalSince1970];
    req.a = kLQAPPKEY;
    NSString *s = [NSString stringWithFormat:@"%@%@", req.a ,@(req.t)];
    req.s = [[s  stringMD5] lowercaseString];
    req.rk = userManager.restrictToken;
    [req requestWithCompletion:^(id response) {
        LQTokenRegsterRes *res = (LQTokenRegsterRes *)response;
        if (res.ret == kLQNetResponseSuccess) {
            userManager.authorizeToken = res.tk;
            userManager.restrictToken = res.rk;
            [userManager saveCurrentUser];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)versionCheck
{
    LQVersionsReq *req = [[LQVersionsReq alloc] init];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        self.versionObj = [[LQVersionObj alloc] initWith:res.data];
        self.appStatus = !self.versionObj.alert;
        [self saveConfiger];
        
        [[LQAppConfiger shareInstance] __versionCheck];
    } error:^(id error) {
        [[LQAppConfiger shareInstance] __versionCheck];
    }];
}

-(void)__versionCheck
{
    if ([[AppUtils bundleVersion] integerValue]<self.versionObj.versionCode) { // 需要更新
        if (self.versionObj.forceUpdate) { // 强制更新逻辑
            [UIViewController.topViewController_ alertViewShowWithTitle:stringNotNil(self.versionObj.title)
                                                                message:stringNotNil(self.versionObj.content)
                                                                 cancel:@"更新"
                                                                  other:nil
                                                           clickedBlock:^(BOOL isTrue) {
                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/id1385370872?l=zh&ls=1&mt=8"]];
                                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                   exit(0);
                                                               });
                                                           }];
            return;
        }
        
        [UIViewController.topViewController_ alertViewShowWithTitle:stringNotNil(self.versionObj.title)
                                                            message:stringNotNil(self.versionObj.content)
                                                             cancel:@"取消"
                                                              other:@"更新"
                                                       clickedBlock:^(BOOL isTrue) {
                                                           if (!isTrue) { return ;}
                                                       //https://itunes.apple.com/us/app/今日足球赛事-每日足球赛事比分文字实时播报/id1385370872?l=zh&ls=1&mt=8
                                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/id1385370872?l=zh&ls=1&mt=8"]];
                                                       }];
        return;
    }
}

@end


@implementation LQVersionObj

-(id)initWith:(NSDictionary *)dic
{
    if (!dic) {return nil;}
    self = [super init];
    if (!self) {return nil;}
    startParser(dic, self, LQVersionObj)
    parserObjAttr(title)
    parserObjAttr(content)
    parserObjAttr(versionName)
    parserObjAttr(updateTime)
    parserObjAttr(downloadUrl)
    parserObjAttr(checksum)
    parserBaseAttr(forceUpdate, integerValue)
    parserBaseAttr(versionCode, integerValue)
    parserBaseAttr(alert, integerValue)

    return self;
}

-(NSDictionary *)toJSON
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    __setObjAttr(json, title)
    __setObjAttr(json, content)
    __setObjAttr(json, versionName)
    __setObjAttr(json, updateTime)
    __setObjAttr(json, downloadUrl)
    __setObjAttr(json, checksum)

    __setBaseAttrInsist(json, forceUpdate)
    __setBaseAttrInsist(json, versionCode)
    __setBaseAttrInsist(json, alert)

    return json.copy;
}

@end

