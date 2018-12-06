//
//  LequSDKMgr.m
//  LequSDKMgr
//
//  Created by 莫 东荣 on 13-4-9.
//  Copyright (c) 2013年 莫 东荣. All rights reserved.
//

#import "LequSDKMgr.h"
#include "LequViewController.h"
#include "LequGetWifiMac.h"


#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import <AdSupport/ASIdentifierManager.h>
#include "LequNotifications.h"

#if weixin
#import "WXApi.h"
#endif

#define applepay 0

#if applepay
#import <AlipaySDK/AlipaySDK.h>
#endif

@interface LequSDKMgr ()
{
    NSString* style_name;
    NSString* server_url;
    float scaleValue;
    int tag;
}

@property(assign) int webViewWidth;
@property(assign) int webViewHeight;
@property(assign) int screenWidth;
@property(assign) int screenHeight;

//@property(assign) NSString* openId;
//@property(assign) NSString* loginKey;

@property(assign) NSString *serverId;

- (NSString *)makeParams: (NSMutableArray *) array
                        : (NSString *)nickName;

- (NSString *)md5: (NSString *)str;

- (void)initControll;

- (void)openUrl: (UIViewController *)controller
               : (NSString *)url;
//- (void)openUrl:(UIViewController *)controller : (NSString *)content;



@end

@implementation LequSDKMgr


int otherType   = 1;//除支付外的其它类型
int payType     = 2;//支付类型
int mOpType     = 1;//webview显示类型

static LequSDKMgr* instance = nil;

+ (LequSDKMgr *)getInstance
{
    if (instance == nil) {
        instance = [LequSDKMgr alloc];
        [instance initSDK];
    }
    return instance;
}


- (void)initSDK
{
    //    [self setOpenId:@""];
    //    [self setLoginKey:@""];
    server_url = @"http://pay.lequaso.cn";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server_url forKey:@"lequ_main_url"];
    //    [self setOpenId:[userDefaults stringForKey:@"open_id"]];
    //    [self setLoginKey :[userDefaults stringForKey:@"login_key"]];
    NSString* new_server_url = [userDefaults stringForKey:@"server_url"];
    NSLog(@"new_server_url:%@",new_server_url);
    if(new_server_url != nil && [new_server_url rangeOfString:@"https:"].location == 0){
        server_url = new_server_url;
    }
    style_name = @"sdk";
    [self initControll];
}

-(NSString *)getOpenId{
    NSString *openId = [[NSUserDefaults standardUserDefaults] stringForKey:@"open_id"];
    if (openId==nil) {
        openId=@"";
    }
    return openId;
}


- (void)initSDK:(NSString *)weixinId
{
    [self initSDK];
#if weixin
    [WXApi registerApp:weixinId withDescription:@"weixin"];
#endif
}


- (void)initControll
{
    CGRect rect = [[ UIScreen mainScreen ] bounds];
    
    [self setScreenWidth :rect.size.width];
    [self setScreenHeight : rect.size.height];
    //[self setWebViewWidth:0];
    //[self setWebViewHeight:0];
    
    
    scaleValue = 0.5;
    
    float scale = 1;
    int miniSize = 2;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    float dpi = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
        miniSize = 4;
        if(scale==1)
            miniSize = 8;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    } else {
        dpi = 160 * scale;
    }
    
    float size_h,size_w;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        //by 李少嗨
        if (rect.size.height > rect.size.width) {
            [self setScreenWidth : rect.size.height];
            [self setScreenHeight : rect.size.width];
        }
        else {
            [self setScreenWidth : rect.size.width];
            [self setScreenHeight : rect.size.height];
        }
        
        size_h = [self screenHeight ] * (1 /scaleValue) / dpi;
        
        if(size_h>miniSize)
            size_h = miniSize;
        else{
            size_h *= 0.95;
        }
        size_w = size_h * 1.6;
        float max_w = ([self screenWidth ] * (1 /scaleValue) / dpi);
        if(size_w > max_w)
            size_w = max_w;
    }
    else
    {
        [self setScreenWidth : rect.size.width];
        [self setScreenHeight :rect.size.height];
        
        size_w = [self screenWidth ] * (1 /scaleValue) / dpi;
        if(size_w > miniSize){
            size_w = miniSize;
        }else{
            size_w *= 0.95;
        }
        size_h = size_w;
    }
    
    //    [self setWebViewWidth:dpi * size_w * scaleValue];
    //    [self setWebViewHeight:dpi * size_h * scaleValue];
    
    [self setWebViewSize:otherType];
    
    
}


-(void)setWebViewSize:(int)opType
{
    mOpType = opType;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect rect = [[ UIScreen mainScreen ] bounds];
    //竖屏的宽高
    float screenWidth = rect.size.width;
    float screenHeight = rect.size.height;
    
    NSLog(@"screen:%fheight:%fori:%ld",screenWidth,screenHeight,(long)orientation);
    
    if(mOpType == payType){//除了支付界面全屏其它按比例显示
        [self setWebViewHeight:screenHeight];
        [self setWebViewWidth:screenWidth];
        if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
        {
            if(screenWidth < screenHeight){
                [self setWebViewHeight:screenWidth];
                [self setWebViewWidth:screenHeight];
            }
        }else{//竖屏
            if(screenWidth > screenHeight){
                [self setWebViewHeight:screenWidth];
                [self setWebViewWidth:screenHeight];
            }
        }
    }else{
        /*
         *根据屏幕宽高比显示webview
         //横竖屏比率 横屏先计算高占屏幕的百分比  竖屏先计算宽
         final static double LANDSCAPE_HEIGHT = 0.73;
         final static double LANDSCAPE_WIDTH = 1.48;
         final static double PORTRAIT_WIDTH = 0.82;
         final static double PORTRAIT_HEIGHT = 0.9;
         */
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            if(screenWidth < screenHeight){
                screenWidth = rect.size.height;
                screenHeight = rect.size.width;
            }
            
            float webviewHight = screenHeight * 0.73;
            [self setWebViewHeight:webviewHight];
            [self setWebViewWidth:webviewHight * 1.48];
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
        }else{
            if(screenWidth > screenHeight){
                screenWidth = rect.size.height;
                screenHeight = rect.size.width;
            }
            
            float webviewWidth = screenWidth * 0.82;
            [self setWebViewWidth:webviewWidth];
            [self setWebViewHeight:webviewWidth * 0.9];
            NSLog(@"UIInterfaceOrientationPortrait");
        }
    }
}


-(void)setStyleName:(NSString*)styleName
{
    style_name = styleName;
}


-(void)openUrl:(UIViewController *)controller
              :(NSString *)url{
    LequViewController *aview = [[LequViewController alloc] init];
    [aview setView:[self webViewWidth] :[self webViewHeight] :[self screenWidth ] :[self screenHeight ]];
    BOOL hasCorner = mOpType == payType ? NO : YES;
    [aview setHasCorner:hasCorner];
    [aview setIsHidden:controller.navigationController.navigationBarHidden];
    aview.view.tag = 10001;
//    [controller.view addSubview : aview.view];
//    [controller addChildViewController:aview];
    [aview loadWebPageWithString:url];
//    [aview.navigationController setNavigationBarHidden:YES];
    
    [controller presentViewController:aview animated:YES completion:^{}];
    
}

-(void)openJSbyContent:(UIViewController *)controller
                      :(NSString *)content{
    
    NSLog(@"contetn:%@", content);
    NSString *jsCmd = [NSString stringWithFormat:@"(function(){Core.Data.success_msg='%@';window.location.hash='#pay_result&force';})()",content];
    LequViewController *aview = nil;
    UIView *view = [controller.view viewWithTag:10001];
    for (UIView* next = view; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LequViewController class]]) {
            aview = (LequViewController*)nextResponder;
            NSLog(@"find it==========================");
            break;
        }
    }
    
    
    if (aview) {
        [aview loadWebPageWithJs:jsCmd];
    }
    
    
}

#pragma regist
- (void)openRegist: (NSString *)appId
                  : (NSString *)appKey
                  : (UIViewController *)controller;{
    
    [self openRegist:appId :appKey : controller : @"" : @"" : @""];
}


- (void)openRegist: (NSString *)appId
                  : (NSString *)appKey
                  : (UIViewController *)controller
                  : (NSString *)userName
                  : (NSString *)passWord{
    
    [self openRegist:appId :appKey : controller : @"" : userName : passWord];
}

- (void)openRegist: (NSString *)appId
                  : (NSString *)appKey
                  : (UIViewController *)controller
                  : (NSString *)inviterCode{
    
    [self openRegist:appId :appKey :controller :inviterCode :@"" :@""];
}
- (NSString *)paramStringFromParams:(NSDictionary *)params{
    NSMutableString *returnValue = [[NSMutableString alloc]initWithCapacity:0];
    NSArray *paramsAllKeys = [params allKeys];
    for(int i = 0;i < paramsAllKeys.count;i++)
    {
        /*
         在此进行处理
         */
        [returnValue appendFormat:@"%@=%@",[paramsAllKeys objectAtIndex:i],[self encodeURIComponent:[params objectForKey:[paramsAllKeys objectAtIndex:i]]]];
        if(i < paramsAllKeys.count - 1)
        {
            [returnValue appendString:@"&"];
        }
    }
    return returnValue;
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
//特殊字符处理

-(NSString*)encodeURIComponent:(NSString*)str{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}
- (void)openRegist: (NSString *)appId
                  : (NSString *)appKey
                  : (UIViewController *)controller
                  : (NSString *) inviterCode
                  : (NSString *)userName
                  : (NSString *)passWord{
    appId_ = appId;
    appKey_ = appKey;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"open_id"]!=nil) {
        return;
    }

//    NSString *jsonS = [NSString stringWithFormat:@"username=%@&password=%@&old_username=&type=-1&app_id=%@",[self createRandomCode:NO :8],[self createRandomCode:NO :8],appId_] ;
    NSMutableDictionary *jsonD = [[NSMutableDictionary alloc] init];
    [jsonD setObject:[self createRandomCode:NO :8] forKey:@"username"];
    [jsonD setObject:[self createRandomCode:NO :8] forKey:@"password"];
    [jsonD setObject:@"" forKey:@"old_username"];
    [jsonD setObject:@"-1" forKey:@"type"];
    [jsonD setObject:appId forKey:@"app_id"];
    
    NSString *login_url = [NSString stringWithFormat:@"%@/sdk/register?format=json",server_url];
    
    [self postWithUrl:login_url
                 body:[[self paramStringFromParams:jsonD] dataUsingEncoding:NSUTF8StringEncoding]
              success:^(NSDictionary *response) {
                  NSLog(@"===>success:%@",response);
                  
                  if ([[NSString stringWithFormat:@"%@",[response objectForKey:@"code"]] isEqualToString:@"0"]) {
                      NSString *new_openId = @"";
                      NSString *new_token = @"";
                      NSString *new_timestamp = @"";
                      NSString *new_loginKey = @"";
                      
                      new_openId = [[response objectForKey:@"msg"] objectForKey:@"open_id"];
                      new_token = [[response objectForKey:@"msg"] objectForKey:@"token"];
                      new_timestamp = [[response objectForKey:@"msg"] objectForKey:@"timestamp"];
                      new_loginKey = [[response objectForKey:@"msg"] objectForKey:@"login_key"];
                      
                      if(![[NSString stringWithFormat:@"%@",new_openId] isEqualToString:@""]){
                          
                          [[LequLoginInfo getInstance] setOpenId:new_openId];
                          [[LequLoginInfo getInstance] setToken:new_token];
                          [[LequLoginInfo getInstance] setTimestamp:new_timestamp];
                          
                          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                          [userDefaults setObject:new_openId forKey:@"open_id"];
                          [userDefaults setObject:new_loginKey forKey:@"login_key"];
                          [userDefaults synchronize];
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:LequLoginNotification object:@""];
                          return;
                      } else{
                          NSLog(@"===>error  new_openId == nil ");
                      }
                  } else{
                      NSLog(@"===>error   code!=0 :%@",[response objectForKey:@"msg"]);
                  }
                  
                 } failure:^(NSError *error) {
                     NSLog(@"error:%@",error.description);
                 }];
    
//    NSURL * URL = [NSURL URLWithString:[login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL];
//    [request setHTTPBody:[[self paramStringFromParams:jsonD] dataUsingEncoding:NSUTF8StringEncoding]];
//    NSURLResponse * response = nil;
//    NSError * error = nil;
//    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"error :%@",error.description);
//    }else{
//
//        NSString *result = [[NSString alloc] initWithData:backData  encoding:NSUTF8StringEncoding];
//        if([result rangeOfString: @"\"open_id\":"].location != NSNotFound){
//
//            NSString *pattern = @"\"(open_id|token|timestamp|login_key)\"\\s?:\\s?\"?(\\w+)[\"\\,\\}]?";
//            NSError *err = nil;
//            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
//            NSArray *matches =  [reg matchesInString:result options:0 range:NSMakeRange(0, [result length])];
//
//            NSString *new_openId = @"";
//            NSString *new_token = @"";
//            NSString *new_timestamp = @"";
//            NSString *new_loginKey = @"";
//
//            for (NSTextCheckingResult *match in matches)
//            {
//                NSRange range1 = [match rangeAtIndex:1];
//                NSRange range2 = [match rangeAtIndex:2];
//                NSString *paramName = [result substringWithRange:range1];
//                NSString *_value = [result substringWithRange:range2];
//
//                if ([paramName isEqualToString:@"open_id"]) {
//                    new_openId = _value;
//                    //                        [self setOpenId:new_openId];
//                }
//                else if ([paramName isEqualToString:@"token"])
//                {
//                    new_token = _value;
//                }
//                else if ([paramName isEqualToString:@"timestamp"])
//                {
//                    new_timestamp = _value;
//                }
//                else if ([paramName isEqualToString:@"login_key"])
//                {
//                    new_loginKey = _value;
//                    //                        [self setLoginKey : new_loginKey];
//                }
//            }
//            if(!([new_openId isEqualToString:@""])){
//
//                [[LequLoginInfo getInstance] setOpenId:new_openId];
//                [[LequLoginInfo getInstance] setToken:new_token];
//                [[LequLoginInfo getInstance] setTimestamp:new_timestamp];
//
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setObject:new_openId forKey:@"open_id"];
//                [userDefaults setObject:new_loginKey forKey:@"login_key"];
//                [userDefaults synchronize];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:LequLoginNotification object:@""];
//                return;
//            }
//
//        }
//    }
    
}
/**
 *  异步POST请求:以body方式,支持数组
 *
 *  @param url     请求的url
 *  @param body    body数据
 *  @param show    是否显示HUD
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)postWithUrl:(NSString *)url
               body:(NSData *)body
            success:(void(^)(NSDictionary *response))success
            failure:(void(^)(NSError *error))failure
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    request.timeoutInterval= 5000;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) { //请求失败
                                                        failure(error);
                                                    } else {  //请求成功
                                                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        success(dic);
                                                    }
                                                }];
    
    [dataTask resume];
}
#pragma login
- (void)openLogin: (NSString *)appId
                 : (NSString *)appKey
                 : (UIViewController *)controller;{
    
    [self openLogin:appId :appKey : controller : @"" : @"" : @""];
}

- (void)openLogin: (NSString *)appId
                 : (NSString *)appKey
                 : (UIViewController *)controller
                 : (NSString *)userName
                 : (NSString *)passWord{
    
    [self openLogin:appId :appKey : controller : @"" : userName : passWord];
}

- (void)openLogin: (NSString *)appId
                 : (NSString *)appKey
                 : (UIViewController *)controller
                 : (NSString *) inviterCode{
    
    [self openLogin:appId :appKey :controller :inviterCode :@"" :@""];
}

- (void)openLogin: (NSString *)appId
                 : (NSString *)appKey
                 : (UIViewController *)controller
                 : (NSString *) inviterCode
                 : (NSString *)userName
                 : (NSString *)passWord{
    
    [self setWebViewSize:otherType];
    tag = 0;
    NSString *login_url = [NSString stringWithFormat:@"%@/static/%@/login.html",server_url,style_name];
    
    appId_ = appId;
    appKey_ = appKey;
    
    NSMutableArray *_firstArray = nil;
    
    if ([userName isEqualToString:@""] == false && [passWord isEqualToString:@""] == false) {
        NSString *userName_ = [NSString stringWithFormat:@"username=%@",userName];
        NSString *passWord_ = [NSString stringWithFormat:@"password=%@", passWord];
        _firstArray = [NSMutableArray arrayWithObjects:userName_,passWord_,nil];
        
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *new_openId_value = [userDefaults stringForKey:@"open_id"];
        
        if ([new_openId_value isEqualToString:@""] || new_openId_value == nil) {
            _firstArray = [NSMutableArray arrayWithObjects:nil];
        }
        else
        {
            NSString *new_openId = [NSString stringWithFormat:@"open_id=%@",new_openId_value];
            NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@", [userDefaults stringForKey:@"login_key"]];
            _firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,nil];
        }
    }
    inviterCode_ = [inviterCode isEqualToString:@""] ? [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Lequ_SDK_IVC"] : inviterCode;
    
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:@""];
    
    NSDate *localDate = [NSDate date];
    double curTime = [localDate timeIntervalSince1970];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double last_open_time = [userDefaults doubleForKey:@"last_open_time"];
    if(last_open_time < 1){//首次登录
        last_open_time = curTime;
    }
    [userDefaults setDouble:curTime forKey:@"last_open_time"];
    [userDefaults synchronize];
    if (curTime - last_open_time > 600*6*24*7) {
        
        NSString *login_url = [NSString stringWithFormat:@"%@/sdk/login/json?%@",server_url, params];
        NSURL * URL = [NSURL URLWithString:[login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            
        }else{
            
            NSString *result = [[NSString alloc] initWithData:backData  encoding:NSUTF8StringEncoding];
            if([result rangeOfString: @"\"open_id\":"].location != NSNotFound){
                
                NSString *pattern = @"\"(open_id|token|timestamp|login_key)\"\\s?:\\s?\"?(\\w+)[\"\\,\\}]?";
                NSError *err = nil;
                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
                NSArray *matches =  [reg matchesInString:result options:0 range:NSMakeRange(0, [result length])];
                
                NSString *new_openId = @"";
                NSString *new_token = @"";
                NSString *new_timestamp = @"";
                NSString *new_loginKey = @"";
                
                for (NSTextCheckingResult *match in matches)
                {
                    NSRange range1 = [match rangeAtIndex:1];
                    NSRange range2 = [match rangeAtIndex:2];
                    NSString *paramName = [result substringWithRange:range1];
                    NSString *_value = [result substringWithRange:range2];
                    
                    if ([paramName isEqualToString:@"open_id"]) {
                        new_openId = _value;
                        //                        [self setOpenId:new_openId];
                    }
                    else if ([paramName isEqualToString:@"token"])
                    {
                        new_token = _value;
                    }
                    else if ([paramName isEqualToString:@"timestamp"])
                    {
                        new_timestamp = _value;
                    }
                    else if ([paramName isEqualToString:@"login_key"])
                    {
                        new_loginKey = _value;
                        //                        [self setLoginKey : new_loginKey];
                    }
                }
                if(!([new_openId isEqualToString:@""])){
                    
                    [[LequLoginInfo getInstance] setOpenId:new_openId];
                    [[LequLoginInfo getInstance] setToken:new_token];
                    [[LequLoginInfo getInstance] setTimestamp:new_timestamp];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:new_openId forKey:@"open_id"];
                    [userDefaults setObject:new_loginKey forKey:@"login_key"];
                    [userDefaults synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:LequLoginNotification object:@""];
                    return;
                }
                
            }
        }
    }
    
    login_url = [NSString stringWithFormat:@"%@#%@",login_url, params];
    NSLog(@"url:%@", login_url);
    
    [[LequSDKMgr getInstance] openUrl:controller :login_url];
    
}

#pragma log
- (void)log: (NSString*)log_key
           : (NSInteger)log_data
           : (NSString*)log_remark{
    
    NSMutableArray *_firstArray = nil;
    
    NSString *log_url = [NSString stringWithFormat:@"%@/service/log",server_url];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *new_openId = [NSString stringWithFormat:@"open_id=%@",[userDefaults stringForKey:@"open_id"]];
    NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@", [userDefaults stringForKey:@"login_key"]];
    //    NSString *openId_ = [NSString stringWithFormat:@"open_id=%@",_openId];
    //    NSString *loginKey_ = [NSString stringWithFormat:@"login_key=%@", _loginKey];
    NSString *new_logKey = [NSString stringWithFormat:@"log_key=%@", log_key];
    NSString *new_logData = [NSString stringWithFormat:@"log_data=%ld", (long)log_data];
    NSString *new_logRemark = [NSString stringWithFormat:@"log_remark=%@", log_remark];
    _firstArray = [NSMutableArray arrayWithObjects:new_openId, new_loginKey, new_logKey, new_logData, new_logRemark, nil];
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:@""];
    
    log_url = [NSString stringWithFormat:@"%@#%@",log_url, params];
    
    NSURL *url = [NSURL URLWithString:log_url];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}




- (void)openCenter: (UIViewController *)controller{
    
    [self setWebViewSize:otherType];
    tag = 1;
    NSString *center_url = [NSString stringWithFormat:@"%@/static/%@/center.html",server_url, style_name];
    NSMutableArray *_firstArray;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    if (!(_openId == nil)) {
    NSString *new_openId = [NSString stringWithFormat:@"open_id=%@",[userDefaults stringForKey:@"open_id"]];
    NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@", [userDefaults stringForKey:@"login_key"]];
    _firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,nil];
    //    }
    //    else
    //    {
    
    //        NSString *openId_ = [NSString stringWithFormat:@"open_id=%@", _openId];
    //        NSString *loginKey_ = [NSString stringWithFormat:@"login_key=%@", _loginKey];
    //        _firstArray = [NSMutableArray arrayWithObjects:openId_,loginKey_,nil];
    //    }
    
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:0 forKey:@"last_open_time"];
    //[userDefaults synchronize];
    
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:@""];
    center_url = [NSString stringWithFormat:@"%@#%@",center_url, params];
    [[LequSDKMgr getInstance] openUrl:controller :center_url];
}

- (void)openPay: (NSString *)serverId
               : (NSString *)nickName
               : (NSString *)callBack
               : (UIViewController *)controller{
    
    [self setWebViewSize:payType];
    tag = 2;
    NSString *pay_url = [NSString stringWithFormat:@"%@/static/%@/pay.html",server_url, style_name];
    
    if ([serverId isEqualToString:@""] || [nickName isEqualToString:@""]) {
        return;
    }
    
    
    [self setServerId: serverId];
    
    //    if (_openId == nil) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *new_openId_value = [userDefaults stringForKey:@"open_id"];
    NSString *new_loginKey_value = [userDefaults stringForKey:@"login_key"];
    //    }
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:0 forKey:@"last_open_time"];
    //    [userDefaults synchronize];
    
    NSString *new_openId = [NSString stringWithFormat:@"open_id=%@", new_openId_value];
    NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@",new_loginKey_value];
    NSString *new_serverId = [NSString stringWithFormat:@"server_id=%@", serverId];
    NSString *new_nickName =  [NSString stringWithFormat:@"role_name=%@", nickName];
    NSString *new_callback = [NSString stringWithFormat:@"callback=%@", callBack];
    NSMutableArray *_firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,new_serverId, new_nickName, new_callback,nil];
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:[NSString stringWithFormat:@"%@",nickName]];
    pay_url = [NSString stringWithFormat:@"%@#%@",pay_url, params];
    NSLog(@"%@", pay_url);
    [[LequSDKMgr getInstance] openUrl:controller :pay_url];
}

- (void)openPay: (NSString *)serverId
               : (NSString *)nickName
               : (NSNumber *)payAmount
               : (NSString *)callBack
               : (UIViewController *)controller;{
    
    [self setWebViewSize:payType];
    tag = 3;
    NSString *pay_url = [NSString stringWithFormat:@"%@/static/%@/pay.html",server_url, style_name];
    
    if ([serverId isEqualToString:@""] || [nickName isEqualToString:@""]) {
        return;
    }
    [self setServerId: serverId];
    //    if (_openId == nil) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *new_openId_value = [userDefaults stringForKey:@"open_id"];
    NSString *new_loginKey_value = [userDefaults stringForKey:@"login_key"];
    //    }
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:0 forKey:@"last_open_time"];
    //[userDefaults synchronize];
    
    NSString *new_openId = [NSString stringWithFormat:@"open_id=%@", new_openId_value];
    NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@",new_loginKey_value];
    NSString *new_serverId = [NSString stringWithFormat:@"server_id=%@", serverId];
    NSString *new_nickName =  [NSString stringWithFormat:@"role_name=%@", nickName];
    NSString *new_payAmount = [NSString stringWithFormat:@"amout=%@", payAmount];
    NSString *new_callback = [NSString stringWithFormat:@"callback=%@", callBack];
    NSMutableArray *_firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,new_serverId, new_nickName, new_payAmount, new_callback,nil];
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:[NSString stringWithFormat:@"%@", nickName ]];
    pay_url = [NSString stringWithFormat:@"%@#%@",pay_url, params];
    NSLog(@"%@", pay_url);
    [[LequSDKMgr getInstance] openUrl:controller :pay_url];
}

- (void)openShare: (UIViewController *)controller{
    
    [self setWebViewSize:otherType];
    tag = 4;
    NSString *share_url = [NSString stringWithFormat:@"%@/static/%@/share.html",server_url, style_name];
    
    NSMutableArray *_firstArray;
    //    if (!(_openId == nil)) {
    //        NSString *new_openId = [NSString stringWithFormat:@"open_id=%@",_openId];
    //        NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@", _loginKey];
    //        _firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,nil];
    //    }
    //    else
    //    {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *new_openId_value = [userDefaults stringForKey:@"open_id"];
    NSString *new_loginKey_value = [userDefaults stringForKey:@"login_key"];
    //    }
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:0 forKey:@"last_open_time"];
    //[userDefaults synchronize];
    
    NSString *new_openId = [NSString stringWithFormat:@"open_id=%@", new_openId_value];
    NSString *new_loginKey = [NSString stringWithFormat:@"login_key=%@",new_loginKey_value];
    _firstArray = [NSMutableArray arrayWithObjects:new_openId,new_loginKey,nil];
    //    }
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:0 forKey:@"last_open_time"];
    //[userDefaults synchronize];
    
    NSString *params = [[LequSDKMgr getInstance] makeParams:_firstArray:@""];
    share_url = [NSString stringWithFormat:@"%@#%@",share_url, params];
    [[LequSDKMgr getInstance] openUrl:controller :share_url];
}


- (NSString *)makeParams:(NSMutableArray *)array
                        : (NSString *)nickName{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"timestamp=%.0f", a];
    
    NSString* dec = [NSString stringWithFormat:@"%@%@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
    //    NSString* mac = [LequGetWifiMac macaddress];
    NSString* mac_ = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        NSString *mac = @"";
        @try {
            mac = [LequGetWifiMac macaddress];
            
            if (mac == nil) {
                mac_  = @"";
            }
            else
            {
                mac_  = mac;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else
    {
        
        NSString *str = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        mac_ = str;
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGSize size = rect.size;
    CGFloat width = size.width * scale_screen;
    CGFloat height = size.height * scale_screen;
    CGFloat webWidth = [self webViewWidth];
    CGFloat webHeight = [self webViewHeight];
    
    if (scaleValue == 0.5) {
        webWidth *= 2;
        webHeight *=2;
    }
    
    
    NSString *dis = [NSString stringWithFormat:@"%.0f_%.0f", width, height];
    NSString *arg = [NSString stringWithFormat:@"%@|%@|%@|%.0f_%.0f",dec,dis,mac_, webWidth, webHeight];
    
    arg = [arg stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *mobileKey = [NSString stringWithFormat:@"mobile_key=%@",[arg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *appId = [NSString stringWithFormat:@"app_id=%@",appId_];
    NSString *ver = [NSString stringWithFormat:@"ver=20160219"];//版本号：20140920
    
    
    [array addObject:timeString];
    [array addObject:mobileKey];
    [array addObject:appId];
    [array addObject:ver];
    
    if (inviterCode_ != nil) {
        NSString* userData = [NSString stringWithFormat:@"ivc=%@",[inviterCode_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [array addObject:userData];
    }
    
    NSMutableArray *paramsArray = array;
    
    NSArray *_sortedArray= [array sortedArrayUsingSelector:@selector(compare:)];
    NSString *string = [_sortedArray componentsJoinedByString:@"&"];
    NSLog(@"string:%@",[NSString stringWithFormat:@"%@&%@",string,appKey_]);
    NSString *sign = [[LequSDKMgr getInstance] md5:[NSString stringWithFormat:@"%@&%@",string,appKey_]];
    NSLog(@"sign:%@",sign);
    
    if (![nickName isEqualToString:@""]) {
        //充值
        [paramsArray removeObjectAtIndex:3];
        NSString *str = [NSString stringWithFormat:@"role_name=%@", [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [paramsArray addObject:str];
        NSArray *_sortedArray= [paramsArray sortedArrayUsingSelector:@selector(compare:)];
        string = [_sortedArray componentsJoinedByString:@"&"];
    }
    
    
    NSString *newString_ = [NSString stringWithFormat:@"%@&sign=%@",string,sign];
    NSLog(@"newstring:%@",newString_);
    return newString_;
}

-(void)checkAilpay: (NSURL *)url
                  : (UIViewController *)controller{
    
#if applepay
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultdic:%@", resultDic);
            [self openJSbyContent:controller : [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"memo"]] ];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultdic:%@", resultDic);
            [self openJSbyContent:controller : [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"memo"]] ];
        }];
    }
#endif
}


- (void)applePayCallBack: (NSString *)appleUrl
                        : (SKPaymentTransaction *)transaction
                        : (NSString *)resultStr{
    
//#if applepay
    NSURL *url = [NSURL URLWithString:appleUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str = [NSString stringWithFormat:@"serverId=%@&openId=%@&receipt-data=%@", [self serverId], [self getOpenId], transaction];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSString *jsCmd = [NSString stringWithFormat:@"(function(){Core.Data.success_msg='%@';window.location.hash='#pay_result&force';})()", resultStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LequIapController" object:jsCmd];
//#endif
    //    if([webView_]){
    //        [webView_ stringByEvaluatingJavaScriptFromString:jsCmd];
    //    }
    //
    
}




-(NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *md5Sing = [NSString stringWithFormat:
                         @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ];
    return [md5Sing lowercaseString];
    
}

/**
 * 获取随机字符串
 * @param numberFlag 是否需要数字（注：true全是数字   false部分数字）
 * @param length     字符串长度
 */
-(NSString *)createRandomCode:(BOOL) numberFlag
                             :(int)length {
    
    NSString *strTable = numberFlag==YES?@"1234567890":@"1234567890abcdefghijkmnpqrstuvwxyz";
    //初始化一个lendth长的的字符串
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0 ; i < length ; i++) {
        [randomString appendFormat: @"%C", [strTable characterAtIndex: arc4random_uniform([strTable length])]];
    }
    return randomString;
}

@end

