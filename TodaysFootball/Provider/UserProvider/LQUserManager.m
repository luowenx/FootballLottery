//
//  LQUserManager.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQUserManager.h"
#import "LQUsersReq.h"
#import "LQLoginRes.h"
#import "LQInfoComment.h"

@interface LQUserManager()<LQEncode>

@end

static LQUserManager *manager;
@implementation LQUserManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LQUserManager alloc] init];
        NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:kLQPathWithUserInfo];
        [manager configureWithDic:infoDic];
    });
    return manager;
}

- (void)configureWithDic:(NSDictionary*)localDic
{
    if (localDic.count == 0) {
        return;
    }
    startParser(localDic, self, LQUserManager)
    inobj.currentUser = [[LQUserInfo alloc] initWith:localDic[@"currentUser"]];
    parserObjAttr(authorizeToken)
    parserObjAttr(restrictToken)
    self.praiseDic = [NSMutableDictionary dictionaryWithDictionary:localDic[@"praiseDic"]?:@{}];
}

- (BOOL)saveCurrentUser
{
    NSDictionary *userDic = self.toJSON;
    if (userDic.count == 0) {
        return NO;
    }
    return [userDic writeToFile:kLQPathWithUserInfo atomically:YES];
}

- (BOOL)deleteCurrentUser
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kLQPathWithUserInfo]) {
        return [[NSFileManager defaultManager] removeItemAtPath:kLQPathWithUserInfo error:NULL];
    }
    return NO;
}

- (void)logOut
{
    self.currentUser = nil;
    [self saveCurrentUser];
}

-(void)getUsers
{
    LQUsersReq *req = [[LQUsersReq alloc] init];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        if (res.ret == 0) {
            LQUserInfo *user = [[LQUserInfo alloc] initWith:res.data];
            userManager.currentUser = user;
            [userManager saveCurrentUser];
        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark == getter、setter
-(BOOL)isLogin
{
    return self.currentUser && self.authorizeToken.length > 0 && self.currentUser.state;
}

#pragma mark == LQEncode
-(NSDictionary *)toJSON
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    if (self.currentUser) {
        [json setValue:[self.currentUser toJSON] forKey:@"currentUser"];
    }
    
    if (self.praiseDic.count > 0) {
        [json setValue:self.praiseDic.copy forKey:@"praiseDic"];
    }
    
    __setObjAttr(json, authorizeToken)
    __setObjAttr(json, restrictToken)

    return json.copy;
}

-(NSMutableDictionary *)praiseDic
{
    if (_praiseDic == nil) {
        _praiseDic = @{}.mutableCopy;
    }
    return _praiseDic;
}

@end

@implementation LQUserManager (Praise)

- (void)praiseComm:(LQComment *)comm
{
    if ([self containsComm:comm]) {
        [self.praiseDic removeObjectForKey:praiseKey(comm)];
        [self saveCurrentUser];
        return;
    }
    [self.praiseDic setValue:@(YES) forKey:praiseKey(comm)];
    [self saveCurrentUser];
}

- (BOOL)containsComm:(LQComment *)comm
{
    return [[self.praiseDic valueForKey:praiseKey(comm)] boolValue];
}

NSString * praiseKey(LQComment * comm)
{
    return comm.id;
}

@end


