//
//  LQHttpRequest.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQHttpRequest.h"
#import "AFNetworkReachabilityManager.h"
#import "LQAppConfiger.h"
#import "BANetManagerCache.h"

#import <Foundation/NSURLResponse.h>

@interface LQHttpRequest () {
    NSMutableDictionary *internalParameter_;
    
    NSString *internalParametersPairsValue_;
}

@end

@implementation LQHttpRequest

-(instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [BANetManager sharedBANetManager].timeoutInterval = 10;
        });
        self.showReachableJargon = YES;
        self.isNeedCache = NO;
        self.method = BAHttpRequestTypeGet;
        self.limitType = kHTTPRequestLimitTypeAuthentication;
    }
    return self;
}

- (NSDictionary *)parameters
{
    if (!internalParameter_) {
        internalParameter_ = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self buildRequestParameterWithDictionary:internalParameter_];
        [self parametersPairsValue];
    }
    
    return internalParameter_;
}

- (NSString *)parametersPairsValue
{
    if (!self.parameters || self.parameters.count == 0) {
        return nil;
    }
    if ([internalParametersPairsValue_ length] == 0) {
        NSArray *sortedArray = [[self.parameters allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
        NSMutableArray *mutablePairs = [[NSMutableArray alloc] init];
        for (NSString *key in sortedArray) {
            [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@",key, self.parameters[key]]];
        }
        internalParametersPairsValue_ = [mutablePairs componentsJoinedByString:@"&"];
    }
    return internalParametersPairsValue_;
}

-(void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters
{
    
}

- (void)apendRelativeUrlWith:(NSString *)apendStr
{
    self.relativeUrl = [self.relativeUrl stringByAppendingString:apendStr];
}

- (LQNetResponse *)httpResponseParserData:(id)aData
{
    return [[LQNetResponse alloc] initWith:aData];
}

BOOL lq_NetReachable()
{
    return ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable);
}


-(NSString *)urlString
{
    return [NSString stringWithFormat:@"%@%@", self.hostUrl.length>0?self.hostUrl:lqUrl, self.relativeUrl];
}

- (void)requestWithCompletion:(HTTPSuccessBlock)completionBlock error:(HTTPErrorBlock)errorBlock
{
    if (self.limitType == kHTTPRequestLimitTypeAuthentication) {
        if (!userManager.authorizeToken) {// token 没有
            [[LQAppConfiger shareInstance] forceBoot];
        }
        [BANetManager ba_setValue:userManager.authorizeToken forHTTPHeaderKey:@"x-lw-app"];
    }
    
    BOOL cache = self.isNeedCache;
    if(cache) {
        cache = [BANetManagerCache ba_httpCacheWithUrlString:self.urlString parameters:self.parameters] != nil;
    }

    // 无网
    if (!lq_NetReachable() && !cache) {
        if(self.showReachableJargon){
            [LQJargon hiddenJargon:@"无法连接到网络" delayed:1];
        }
        NSError *error = [[NSError alloc] initWithDomain:@"网络连接断开"
                                                    code:kLQNetErrorCodeNotReachable
                                                userInfo:nil];
        errorBlock?errorBlock(error):nil;
        return;
    }
    
    [BANetManager ba_requestWithType:self.method
                         isNeedCache:self.isNeedCache
                           urlString:self.urlString
                          parameters:self.parameters
                        successBlock:^(id response) {
                            LQNetResponse * res = [self httpResponseParserData:(NSDictionary *)response];
                            
                            if (res.ret == kLQNetResponseTKOverdue) { // token 过期
                                [[LQAppConfiger shareInstance] getRegisterToken];
                            }else if (res.ret == kLQNetResponseNeedLogin){  // 需要登录
                                [userManager logOut];
                                [LQJargon hiddenJargon:@"登录失效"];
                                [UIViewController popToRootViewCtrl:NSClassFromString(@"LQMyVC")];
                            }
                            completionBlock?completionBlock(res):nil;
                        } failureBlock:errorBlock progressBlock:nil];
    
}

@end

