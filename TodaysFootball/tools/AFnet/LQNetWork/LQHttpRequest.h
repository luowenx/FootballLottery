//
//  LQHttpRequest.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/15.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IHttpResponseProtocol <NSObject>

/**
 *  构造请求消息头数据
 *
 *  @param aParameters 消息头
 */
- (void)buildRequestParameterWithDictionary:(NSMutableDictionary *)aParameters;

/**
 *  解析请求的结果数据 子类必须实现
 *
 *  @param aData 请求返回的消息体数据中的@"data",
 *
 *  @return 接口请求对应的响应类实例 return:nil表示结果数据错误
 */
- (LQNetResponse *)httpResponseParserData:(id)aData;

@end

//请求限制类型
typedef NS_ENUM(NSInteger, HTTPRequestLimitType)   {
    kHTTPRequestLimitTypeDefault, //没有任何限制
    kHTTPRequestLimitTypeAuthentication, //需要登录权限
};


typedef void (^HTTPSuccessBlock)(id response);
typedef void (^HTTPErrorBlock)(id error);

/**
 网络请求类
 */
@interface LQHttpRequest : NSObject <IHttpResponseProtocol>

/**
 是否显示无网络提示
 */
@property (nonatomic) BOOL showReachableJargon;

//限制类型 默认kHTTPRequestLimitTypeAuthentication
@property (nonatomic, assign) HTTPRequestLimitType limitType;

//自定义请求域名
@property (nonatomic, copy) NSString *hostUrl;

// 是否缓存、默认NO   
@property (nonatomic) BOOL isNeedCache;

//默认 BAHttpRequestTypeGet；
@property (nonatomic, assign) BAHttpRequestType method;

//相对url地址
@property (nonatomic, strong) NSString *relativeUrl;

//参数集
@property (nonatomic, readonly) NSDictionary *parameters;

//参数串
@property (nonatomic, readonly) NSString *parametersPairsValue;


/**
 某些get请求拼接参数

 @param apendStr 要拼接的参数
 */
- (void)apendRelativeUrlWith:(NSString *)apendStr;

/**
 统一的网络请求方式
 
 @param completionBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)requestWithCompletion:(HTTPSuccessBlock)completionBlock error:(HTTPErrorBlock)errorBlock;

// 网络状态
BOOL lq_NetReachable(void);

@end

