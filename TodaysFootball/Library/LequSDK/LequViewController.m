//
//  LequViewController.m
//  LequSDK
//
//  Created by 莫 东荣 on 13-4-9.
//  Copyright (c) 2013年 莫 东荣. All rights reserved.
//

#import "LequViewController.h"
#import "LequNotifications.h"
#import "StoreKit/StoreKit.h"

#import <Foundation/Foundation.h>

//#if weixin
#import "WXApi.h"
#import "WXApiObject.h"
//#endif

#if applepay
#import <AlipaySDK/AlipaySDK.h>
#import "IapController.h"
#endif

#define NEW_ALIPAY 1
#import "IapController.h"
#import "NSURLRequest+SSL.h"


@interface LequViewController ()
{
    
}

@property(assign) int webViewWidth;
@property(assign) int webViewHeight;
@property(assign) int screenWidth;
@property(assign) int screenHeight;
@property(nonatomic,strong)NSString *rediectUrl;

@end

@implementation LequViewController

- (void) dealloc
{
    webView_ = nil;
    activityIndicator = nil;
}



- (void)loadWebPageWithString:(NSString*)urlString
{
    [webView_ stopLoading];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
    NSURL *url =[NSURL URLWithString: urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView_ loadRequest:request];
    //[webView loadData:nil MIMEType:<#(NSString *)#> textEncodingName:<#(NSString *)#> baseURL:<#(NSURL *)#>]
    
}

- (void)loadWebPageWithJs:(NSString *)content
{
    if ([webView_ isLoading]) {
        NSLog(@"webview is loading");
        [webView_ stopLoading];
    }
    NSLog(@"content:%@", content);
    [webView_ stringByEvaluatingJavaScriptFromString:content];
    //    [self loadWebPageWithString:@"http://www.baidu.com"];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_isHidden) {
        [self.navigationController setNavigationBarHidden:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO];
    }
    [super viewWillDisappear:animated];
}


-(void)setView:(int)webViewWidth :(int) webViewHeight :(int) screenwidth :(int) screenHeight
{
    [self setWebViewWidth:webViewWidth];
    [self setWebViewHeight:webViewHeight];
    [self setScreenWidth:screenwidth];
    [self setScreenHeight:screenHeight];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rediectUrl=@"";
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.view setFrame:CGRectMake(0, 0, [self screenWidth], [self screenHeight])];
//    if (@available(iOS 11.0, *)) {
//        [self.view setFrame:CGRectMake(0, 44, [self screenWidth], [self screenHeight])];
//    }
    [self initWebView];
    
    webView_.delegate = self;
    [webView_ setHidden:YES];
    [webView_ setUserInteractionEnabled:YES];
    [webView_ setScalesPageToFit:YES];
    
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"Lequ" ofType:@"json"];
    //    if ([fileManager fileExistsAtPath:path ]) {
    //        return;
    //    }
    //    NSString *_jsonContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //    NSMutableDictionary *dict= [_jsonContent JSONValue];
    //    NSString *string = [dict objectForKey:@"Lequ_sdk_vcr"];
    //    NSLog(@"string:%@", string);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIap:) name:@"LequIapController" object:nil];
    
}

- (void)receiveIap:(NSNotification *)notification
{
    NSLog(@"==============receiveIap");
    
    if (webView_) {
        NSString *jsCmd = [notification object];
        [webView_ stringByEvaluatingJavaScriptFromString:jsCmd];
    }
}

//开始加载时调用的方法
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    
    if (activityIndicator != nil) {
        [activityIndicator removeFromSuperview];
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:webView_.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    NSLog(@"webViewDidStartLoad");
}

//结束加载时调用的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"webViewDidFinishLoad");
    if (webView_ != nil && webView_.isHidden == YES) {
        [webView_ setHidden:NO];
        
    }
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
}

//加载失败时调用的方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    //    UIView *view = (UIView*)[self.view viewWithTag:108];
    //    [view removeFromSuperview];
    
    //    NSString *msg = [NSString stringWithFormat:@"%ld", (long)[error code]];
    
    
    
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    
    NSString *currentURL= webView_.request.URL.absoluteString;
    NSString *errerUrl = @"sdk://error?msg=network_error";
    
    
    NSString *htmlInfo = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width,user-scalable=0\" /><style type=\"text/css\">\nbody{padding-top:50px;line-height:1.5em;font-size:14pt;text-align:center}\na{border:1px solid #ddd;padding:5px 10px;display:inline-block;margin:10px auto;text-decoration:none;}</style></head><body>网络连接异常,无法处理此请求!<br/><a href=\"%@\">重新尝试</a><br/><a href=\"%@\">返回游戏</a></body></html>", currentURL, errerUrl];
    
    [webView_ loadHTMLString:htmlInfo baseURL:[NSURL URLWithString: @""]];
}



// 解析URL参数（根据key获取值）
/*
 * 根据指定的参数名，从URL中找出并返回对应的参数值。
 */
- (NSString *)getValueStringFromUrl:(NSString *)url forParam:(NSString *)param {
    NSString * str = nil;
    NSRange start = [url rangeOfString:[param stringByAppendingString:@"="]];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}
- (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl {
    
    NSString *finalStr = [NSString string];
    NSMutableString * mutStr = [NSMutableString stringWithString:originUrl];
    NSArray *strArray = [mutStr componentsSeparatedByString:parameter];
    NSMutableString *firstStr = [strArray objectAtIndex:0];
    NSMutableString *lastStr = [strArray lastObject];
    NSRange characterRange = [lastStr rangeOfString:@"&"];
    if (characterRange.location !=NSNotFound) {  
        NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"]; 
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray]; 
        [mutArray removeObjectAtIndex:0];  
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"]; 
        finalStr = [[strArray objectAtIndex:0]stringByAppendingString:modifiedStr]; 
    } else {
        finalStr = [firstStr substringToIndex:[firstStr length] -1];  
    }
    return finalStr;
}

//准备加载内容时调用的方法，通过返回值来进行是否加载的设置
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    // Set a flag on iframe navigation, which will not trigger a reset of plugins.
    
    NSString *urlString = [[request URL] absoluteString];
    //    NSString * title = @"";//(pszTitle) ? [NSString stringWithUTF8String : pszTitle] : nil;
    //    NSString * msg = urlString;//(pszMsg) ? [NSString stringWithUTF8String : pszMsg] : nil;
    //    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle: title
    //                                                          message: msg
    //                                                         delegate: nil
    //                                                cancelButtonTitle: @"OK"
    //                                                otherButtonTitles: nil];
    //    [messageBox autorelease];
    //    [messageBox show];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    NSLog(@"shouldStartLoadWithRequest:%@",urlString);
    NSString *redStr = [self getValueStringFromUrl:urlString forParam:@"redirect_url"];
    if (redStr!=nil) {
        _rediectUrl = [self getValueStringFromUrl:urlString forParam:@"redirect_url"];
        urlString = [self deleteParameter:@"redirect_url" WithOriginUrl:urlString];
        NSLog(@"redirect_url:%@",_rediectUrl);
        NSLog(@"new String :%@",urlString);
    }
    NSLog(@"<===============>");

    NSString *str = [urlComps objectAtIndex:0];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"sdk"])
    {
        
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"="];
        NSArray *arrPar = [(NSString *)[arrFucnameAndParameter objectAtIndex:0] componentsSeparatedByString:@"?"];
        NSString *funcStr = (NSString *)[arrPar objectAtIndex:0];
        
        NSLog(@"funstr:%@", funcStr);
        
        //        if (1 == [arrFucnameAndParameter count])
        //        {
        //            // 没有参数
        //            if([funcStr isEqualToString:@"login:"])
        //            {
        //
        //                /*调用本地函数1*/
        //                NSLog(@"doFunc1");
        //            }
        //        }
        //        else
        //        {
        //有参数的
        if([funcStr isEqualToString:@"login"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"(open_id|timestamp|token|login_key)=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSLog(@"urlString%@",urlString);
            NSString *openId = @"";
            NSString *token = @"";
            NSString *timestamp = @"";
            NSString *loginKey = @"";
            for (NSTextCheckingResult *match in matches)
            {
                NSRange range1 = [match rangeAtIndex:1];
                NSRange range2 = [match rangeAtIndex:2];
                NSString *paramName = [sch substringWithRange:range1];
                if ([paramName isEqualToString:@"open_id"]) {
                    openId = [sch substringWithRange:range2];
                }
                else if ([paramName isEqualToString:@"token"])
                {
                    token = [sch substringWithRange:range2];
                }
                else if ([paramName isEqualToString:@"timestamp"])
                {
                    timestamp = [sch substringWithRange:range2];
                }
                else if ([paramName isEqualToString:@"login_key"])
                {
                    loginKey = [sch substringWithRange:range2];
                }
            }
            
            
            NSLog(@"openId:%@, token:%@, timestamp:%@, loginkey:%@", openId, token, timestamp, loginKey);
            
            [[LequLoginInfo getInstance] setOpenId:openId];
            [[LequLoginInfo getInstance] setToken:token];
            [[LequLoginInfo getInstance] setTimestamp:timestamp];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:openId forKey:@"open_id"];
            [userDefaults setObject:loginKey forKey:@"login_key"];
            [userDefaults synchronize];
            
            [reg replaceMatchesInString:sch options:0 range:NSMakeRange(0, [sch length]) withTemplate:@"100"];
            [self postNotification:LequLoginNotification : @""];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];

        }
        else if ([funcStr isEqualToString:@"pay"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSString *orderId = @"";
            
            NSTextCheckingResult *match = matches.firstObject;
            if (match) {
                NSRange range1 = [match rangeAtIndex:1];
                orderId = [sch substringWithRange:range1];
            }
            
            [self postNotification:LequPaytNotification : orderId];
            //                [webView_ setHidden:YES];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];

            NSLog(@"pay");
        }
        else if ([funcStr isEqualToString:@"center"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSString *message = @"";
            for (NSTextCheckingResult *match in matches)
            {
                NSRange range1 = [match rangeAtIndex:1];
                message = [sch substringWithRange:range1];
                
            }
            [self postNotification:LequCenterNotification : message];
            //                [webView_ setHidden:YES];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];
            NSLog(@"center");
        }
        else if ([funcStr isEqualToString:@"share"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSString *message = @"";
            for (NSTextCheckingResult *match in matches)
            {
                NSRange range1 = [match rangeAtIndex:1];
                message = [sch substringWithRange:range1];
                
            }
            [self postNotification:LequShareNotification:message];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];

            NSLog(@"share");
        }
        else if ([funcStr isEqualToString:@"alipay"])
        {
            
            /**
             sdk://alipay?service%3D%22mobile.securitypay.pay%22%26_input_charset%3D%22utf-8%22%26payment_type%3D%221%22%26partner%3D%222088611293152635%22%26seller_id%3D%22shyouaiwlcompany%40163.com%22%26out_trade_no%3D%2256ceb238e1382372dfbd211a%22%26subject%3D%22%E6%B8%B8%E7%88%B1%E6%98%9F%22%26body%3D%22%E6%B8%B8%E7%88%B1%E5%B9%B3%E5%8F%B0%E5%85%85%E5%80%BC%22%26total_fee%3D%220.10%22%26notify_url%3D%22http%3A%2F%2Fsdk.i9133.com%2Fservice%2Fconfirm%2Falisdk%2F54277076e138233137cb4a4a%22%26sign_type%3D%22RSA%22%26sign%3D%22KJOeoCPYMqSm77o2CIkPtZ7mXtj2a1uLVtMpb%252BQwKeiGK4Yn1j0AC2%252FSjq1eXSyWHKVXwMkRS3nIIlr9UlUYMxMeb%252F%252B0w6ZH8U6uu12fK6KSi7glkI7lZ%252Bv%252FXIN5QdQPuLoz7cn%252FCFKTIVL9o4VcNZsPFovfvPMVbB3eRTrBY5U%253D%22
             */
            //                final String orderInfo = URLDecoder.decode(strParams);
            
            //                UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle: title
            //                                                                      message: msg
            //                                                                     delegate: nil
            //                                                            cancelButtonTitle: @"OKdfdafew"
            //                                                            otherButtonTitles: nil];
            //                [messageBox autorelease];
            //                [messageBox show];
            
            NSLog(@"alipay:%@",funcStr);
            NSArray *array = [urlString componentsSeparatedByString:@"?"];
            NSString *urlArg =  (NSString *)[array objectAtIndex:1];
            NSLog(@"urlArg before:%@", urlArg);
            NSString *orderInfo = [urlArg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"urlArg after:%@", orderInfo);
            NSString *appScheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            NSLog(@"appScheme:%@", appScheme);
            
            //新版支付宝
#if applepay
            
#endif
     
        }
        else if ([funcStr isEqualToString:@"applePay"])
        {
#if applepay
            NSArray *array = [urlString componentsSeparatedByString:@"?"];
            NSString *urlArg =  (NSString *)[array objectAtIndex:1];
            
            NSArray *arrFucnameAndParameter = [urlArg componentsSeparatedByString:@"="];
            NSString *product_id = [arrFucnameAndParameter objectAtIndex:0];
            NSString *appleCallBackUrl_ = [arrFucnameAndParameter objectAtIndex:1];
            SKPayment *payment = [SKPayment paymentWithProductIdentifier:product_id];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
            //少海提供
            [[IapController sharedController] setAppleCallBack:appleCallBackUrl_];
#endif
            //                end
            
            //                NSString *orderInfo = [urlArg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //                NSString *appScheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            //                [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //
            //                    NSString *jsCmd = [NSString stringWithFormat:@"(function(){Core.Data.success_msg='%@';window.location.hash='#pay_result&force';})()", [resultDic objectForKey:@"memo"]];
            //                    NSLog(@"-----------------%@", jsCmd);
            //                    [webView_ stringByEvaluatingJavaScriptFromString:jsCmd];
            //                }];
            
        }
        else if ([funcStr isEqualToString:@"changeServer"])
        {
            //                NSError *err;
            //                NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSLog(@"changeServer url");
            NSRange subStr = [urlString rangeOfString:@"="];
            NSString *message = @"";
            if (subStr.location != NSNotFound) {
                NSLog(@"find changeServer url");
                message = [urlString substringFromIndex:subStr.location + 1];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:message forKey:@"server_url"];
            [userDefaults synchronize];
            
            //                NSString *pattern = @"=([^&]+)";
            //                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            //                NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            //
            //                NSString *message = @"";
            //                for (NSTextCheckingResult *match in matches)
            //                {
            //                    NSRange range1 = [match rangeAtIndex:1];
            //                    message = [sch substringWithRange:range1];
            //
            //                }
            //
            //                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //                [userDefaults setObject:message forKey:@"server_url"];
            //                [userDefaults synchronize];
            
        }
        else if ([funcStr isEqualToString:@"open"])
        {
            //                NSError *err;
            //                NSMutableString *sch = [NSMutableString stringWithString:urlString];
            //                NSString *pattern = @"=([^&]+)";
            //                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            //                NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            //
            //                NSString *message = @"";
            //                for (NSTextCheckingResult *match in matches)
            //                {
            //                    NSRange range1 = [match rangeAtIndex:1];
            //                    message = [sch substringWithRange:range1];
            //
            //                }
            //                message = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //                NSRange range = [message rangeOfString:@"%s"];
            //                if (range.length > 0) {
            //                    message = [message stringByReplacingCharactersInRange:range withString:@"%@"];
            //                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //                    [userDefaults setObject:message forKey:@"html"];
            //                    [userDefaults synchronize];
            //                }
            NSLog(@"open url");
            NSRange subStr = [urlString rangeOfString:@"="];
            NSString *message = @"";
            if (subStr.location != NSNotFound) {
                NSLog(@"find open url");
                message = [urlString substringFromIndex:subStr.location + 1];
                NSURL *nsUrl = [NSURL URLWithString:message];
                [[UIApplication sharedApplication] openURL:nsUrl];
            }
            
            
            
            //                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //                [userDefaults setObject:message forKey:@"server_url"];
            //                [userDefaults synchronize];
            
        }
        else if ([funcStr isEqualToString:@"error"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSString *message = @"";
            for (NSTextCheckingResult *match in matches)
            {
                NSRange range1 = [match rangeAtIndex:1];
                message = [sch substringWithRange:range1];
                
            }
            [self postNotification:LequErrorNotification:message];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];

        }
        else if ([funcStr isEqualToString:@"exit"])
        {
            NSError *err;
            NSMutableString *sch = [NSMutableString stringWithString:urlString];
            NSString *pattern = @"=([^&]+)";
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&err];
            NSArray *matches =  [reg matchesInString:sch options:0 range:NSMakeRange(0, [sch length])];
            
            NSString *message = @"";
            for (NSTextCheckingResult *match in matches)
            {
                NSRange range1 = [match rangeAtIndex:1];
                message = [sch substringWithRange:range1];
                
            }
            [self postNotification:LequErrorNotification:message];
            [webView_ removeFromSuperview];
            webView_.delegate = nil;
            [self dismissViewControllerAnimated:YES completion:^{}];

        }
        else if ([funcStr isEqualToString:@"weixin"])
        {
            /**
             urlString	__NSCFString *	@"sdk://weixin?package=Sign%3DWXPay&timestamp=1456372387&sign=7DD1E0A74348F1104B33F7124223B6BE&partnerid=1310689701&appid=wx45a2534d8e0e8b81&prepayid=wx20160225115307a356b03f580568118553&noncestr=8xy5qlb6ys9rf4faoqvw0sph4cposg83"
             */
            NSLog(@"weixin");
            
            NSLog(@"%@",urlString);
            
            
            
//#if weixin
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [self getValueStringFromUrl:urlString forParam:@"partnerid"];//@"10000100";
            request.prepayId= [self getValueStringFromUrl:urlString forParam:@"prepayid"];//@"1101000000140415649af9fc314aa427";
            request.package = [self getValueStringFromUrl:urlString forParam:@"package"];//@"Sign=WXPay";
            request.nonceStr= [self getValueStringFromUrl:urlString forParam:@"noncestr"];//@"a462b76e7436e98e0ed6e13c64b4fd1c";
            request.timeStamp= [self getValueStringFromUrl:urlString forParam:@"timestamp"].intValue;//@"1397527777";
            request.sign= [self getValueStringFromUrl:urlString forParam:@"sign"];//@"582282D72DD2B03AD892830965F428CB16E7A256";
            [WXApi sendReq:request];
            
//            [webView_ removeFromSuperview];
//            webView_.delegate = nil;
//            [self.view removeFromSuperview];
//            [self removeFromParentViewController];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *url = [NSString stringWithFormat:@"%@/service/callback/sdk/wxwap",[userdefault stringForKey:@"lequ_main_url"]];
            [self loadWebPageWithString:url];
            return NO;
//#endif
        }
        return NO;
        
        
        
        
#pragma mark - wap支付
    }else if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"weixin"]){
        NSLog(@"weixin wap pay:%@",urlString);
        NSURL* wxURL = [[NSURL alloc]initWithString:urlString];
        [[UIApplication sharedApplication]openURL:wxURL];
        if (![_rediectUrl isEqual:@""]) {
             [self loadWebPageWithString:_rediectUrl];
            _rediectUrl = @"";
            return NO;
        }else{
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *url = [NSString stringWithFormat:@"%@/service/callback/sdk/wxwap",[userdefault stringForKey:@"lequ_main_url"]];
            [self loadWebPageWithString:url];
            return NO;
        }
    }
    
    else if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"alipay"] || [[urlComps objectAtIndex:0] isEqualToString:@"alipays"])){
        NSURL* alipayURL = [NSURL URLWithString:urlString];
        BOOL bSucc = [[UIApplication sharedApplication]openURL:alipayURL];
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未检测到支付宝客户端，请安装后重试。" delegate:self cancelButtonTitle:@"立即安装" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }else{
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *url = [NSString stringWithFormat:@"%@/service/callback/sdk/wxwap",[userdefault stringForKey:@"lequ_main_url"]];
            [self loadWebPageWithString:url];
            return NO;
//            [webView_ removeFromSuperview];
//            webView_.delegate = nil;
//            [self.view removeFromSuperview];
//            [self removeFromParentViewController];
        }
    }
	    return YES;
    
}

//-(void)xzGET:(NSString *)urls{
//    NSLog(@"===>urls:%@",urls);
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager]; manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"charset=UTF-8" forHTTPHeaderField:@"Accept"];
//    [manager GET:urls parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSRange range1 = [string rangeOfString:@"使用支付宝支付成功,游戏币将会很快充入您的账户,请留意查收。订单号:"];//匹配得到的下标
//        NSRange range = NSMakeRange(range1.location+range1.length, 24);
//        string = [string substringWithRange:range];//截取范围类的字符串
//        NSLog(@"===>success:%@",string);
//        [self postNotification:LequPaytNotification : string];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"===>error:%@",error.description);
//    }];
//    
//}
- (void)postNotification:(NSString *)name : (NSString *)code
{
    if ([name isEqualToString:LequLoginNotification]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else if ([name isEqualToString:LequPaytNotification])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else if ([name isEqualToString:LequShareNotification])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else if ([name isEqualToString:LequCenterNotification])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else if ([name isEqualToString:LequErrorNotification])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else if ([name isEqualToString:LequExitNotification])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:code];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return YES;
}



- (void)initWebView
{
    //html = @"<html><head><style type=\"text/css\">body{background:#2D89EF;color:#fff;font-size:24pt;text-align:center;}p{margin-top:100px;}</style></head><body><p>\u7a0b\u5e8f\u52a0\u8f7d\u4e2d...</p><script type=\"text/javascript\">document.location=\"%@\";</script></body></html>";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* html_ = [userDefault stringForKey:@"html"];
    if (html_ != Nil) {
        NSRange range = [html_ rangeOfString :@"document.location"];
        if (range.length > 0) {
            
        }
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self screenWidth], [self screenHeight])];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
//    [button addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [self webViewWidth],  [self webViewHeight])];
    if([self hasCorner]){
        webView_.layer.cornerRadius = 10;
        [webView_ setClipsToBounds:YES];
    }
    
    [self.view addSubview: webView_];
    
    
//    //plus
//    // by zhanghjiayu
//    if ([self screenWidth] == 414 || [self screenWidth] == 736) {
//
//        [webView_ setFrame:CGRectMake(([self screenWidth] - [self webViewWidth] )/ 2, ([self screenHeight] - ([self webViewHeight]+40))/ 2, [self webViewWidth], ([self webViewHeight]+40))];
//
//    }else{
//
//        [webView_ setFrame:CGRectMake(([self screenWidth] - [self webViewWidth] )/ 2, ([self screenHeight] - [self webViewHeight])/ 2, [self webViewWidth], [self webViewHeight])];
//
//    }

}

//- (void)Btn:(UIButton *)btn {
//
//    
//    [webView_ setHidden:YES];
//    [activityIndicator stopAnimating];
//    [activityIndicator removeFromSuperview];
//}

@end
