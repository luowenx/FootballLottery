
//  IapController.m
//  mangosanguo
//
//  Created by Gino on 12-11-6.
//  Copyright (c) 2012年 private. All rights reserved.



#import "IapController.h"
#import "LequSDKMgr.h"
//#if applepay
#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"


@interface IapController ()
{

}

@property(assign) NSString* appleUrl;

@end

@implementation IapController


static IapController * sharedController = nil;

+ (IapController *) sharedController
{
    if (sharedController != nil) {
        return sharedController;
    }
    sharedController = [[IapController alloc] init];
    return sharedController;
    
}


- (id)init
{
    if ((self = [super init])) {
        
        
    }
    
    payArray = [NSMutableArray arrayWithCapacity:1];
//    [_payArray retain];
    isRequestedBuy = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    return self;
}

- (void)setAppleCallBack: (NSString*)url
{
    [self setAppleUrl : url];
}

- (void)removeIt
{
//    if ([self retainCount] >= 1) {
//        [self release];
//    }
}

// 主动请求app store, 暂不用
- (void)requestProductData
{
    NSLog(@"---------请求对应的产品信息------------requestProductData");
//    NSSet *products = [NSSet setWithObjects:
//                       @"com.mango.sanguo.jinbitest2",
//                       @"com.mango.sanguo.jinbitest3",
//                       @"com.mango.sanguo.jinbitest4",
//                       @"com.mango.sanguo.jinbitest5",
//                       @"com.mango.sanguo.jinbitest6",
//                       @"com.mango.sanguo.jinbitest7",
//                       @"com.mango.sanguo.jinbitest8",
//                       @"com.mango.sanguo.jinbitest9",
//                       @"com.mango.sanguo.jinbitest10",
//                       @"com.mango.sanguo.jinbitest11",
//                       @"com.mango.sanguo.jinbitest12",
//                       nil];
    NSSet *products = [NSSet setWithObjects:
                       @"com.lequwuxian.todaysfootball.colorbean.30",
                       @"com.lequwuxian.todaysfootball.colorbean.60",
                       @"com.lequwuxian.todaysfootball.colorbean.88",
                       @"com.lequwuxian.todaysfootball.colorbean.188",
                       @"com.lequwuxian.todaysfootball.colorbean.388",
                       @"com.lequwuxian.todaysfootball.colorbean.618",
                       nil];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: products];
    request.delegate=self;
    [request start];
}


- (void)requestProductInfoById:(NSString *)str
{
    NSLog(@"---------请求对应的产品信息------------requestProductInfoById");
    NSSet *products = [NSSet setWithObjects:
                       str,
                       nil];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: products];
    request.delegate=self;
    [request start];
}


//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSLog(@"-----------收到产品反馈信息--------------productsRequest");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"货币类型: %@" , [product.priceLocale objectForKey:NSLocaleCurrencySymbol]);
        NSLog(@"Product id: %@" , product.productIdentifier);

        SKPayment *payment = [SKPayment paymentWithProductIdentifier:product.productIdentifier];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }

//    [request autorelease];

/***
 **
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    
    int count = [myProduct count];
    Value vCount = Value(count);
    Json::Value ProductsInfo = Json::arrayValue;
//    ProductsInfo.append(vCount);
    
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"货币类型: %@" , [product.priceLocale objectForKey:NSLocaleCurrencySymbol]);
        NSLog(@"Product id: %@" , product.productIdentifier);

        string str_description = [[product description] UTF8String];
        string str_dlocalizedTitle = [product.localizedTitle UTF8String];
        string str_dlocalizedDescription = [product.localizedDescription UTF8String];
        string str_dprice = [[product.price stringValue] UTF8String];
        string str_dproductIdentifier = [product.productIdentifier UTF8String];
        string str_LocaleCurrencySymbol = [[product.priceLocale objectForKey:NSLocaleCurrencySymbol] UTF8String];
        
        Json::Value item = Json::arrayValue;
        Json::Value description = Value(str_description);
        Json::Value localizedTitle = Value(str_dlocalizedTitle);
        Json::Value localizedDescription = Value(str_dlocalizedDescription);
        Json::Value price = Value(str_dprice);
        Json::Value productIdentifier = Value(str_dproductIdentifier);
        Json::Value LocaleCurrencySymbol = Value(str_LocaleCurrencySymbol);
        
        //item.append(description);
        item.append(localizedTitle);
        item.append(localizedDescription);
        item.append(price);
        item.append(productIdentifier);
        item.append(LocaleCurrencySymbol);
        
        ProductsInfo.append(item);
    }
    
    Json::Value myProduct_ = Value(myProduct);
    GAME_SIMULATOR->sendActionRequest(c2c_iap_response_products, &ProductsInfo,NULL);
    [request autorelease];
 
**/
    
}


// 请求升级数据
- (void)requestProUpgradeProductData
{
    
}


//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
//    [alerView release];
}

// 反馈信息结束
-(void) requestDidFinish:(SKRequest *)request
{
    
}

//  发送购买请求
- (void)requestBuyProduct:(NSString *)identifier
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:identifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    isRequestedBuy = YES;
}


//----监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSString *resultStr = @"未知错误";
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                resultStr = @"支付完成";
                break;
            case SKPaymentTransactionStateFailed:
                switch (transaction.error.code)
                {
                    case SKErrorUnknown:
                        resultStr = @"支付失败,未知错误!";
                        break;
                    case SKErrorClientInvalid:
                        resultStr = @"支付失败,客户拒绝购买请求!";
                        break;
                    case SKErrorPaymentCancelled:
                        resultStr = @"支付失败,用户取消请求!";
                        break;
                    case SKErrorPaymentInvalid:
                        resultStr = @"支付失败,购买产品无效!";
                        break;
                    case SKErrorPaymentNotAllowed:
                        resultStr = @"支付失败,该设备不允许购买!";
                        break;
                    case SKErrorStoreProductNotAvailable:
                        resultStr = @"支付失败,购买产品不存在!";
                        break;
                    default:
                        break;
                }
                break;
            case SKPaymentTransactionStateRestored:
//                [self restoreTransaction:transaction];
                resultStr = @"支付未完成";
                break;
            case SKPaymentTransactionStatePurchasing:
                
                break;
            default:
                break;
                
        }
        
       
        [[LequSDKMgr getInstance] applePayCallBack:[self appleUrl] :transaction :resultStr];
    }
}


-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
//    Json::Value result_ = Value(false);
//    GAME_SIMULATOR->sendActionRequest(c2c_iap_buy_products, &result_,NULL);
//    
    if (isRequestedBuy) {
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"已经成功购买,返回金币需要一段时间，请稍等片刻..！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
        [alerView show];
//        [alerView release];
    }
    
    [self addItemToPayArray:transaction];

    
/****
 ** 旧的验证流程
    Json::Value result_ = Value(false);
    GAME_SIMULATOR->sendActionRequest(c2c_iap_buy_products, &result_,NULL);
    
	
    if ([self putStringToItunes:[transaction transactionReceipt]]) {
        
        if (isRequestedBuy) {
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"已经成功购买,返回金币需要一段时间，请稍等片刻..！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil];
            [alerView show];
            [alerView release];
        }
        
        PayTransaction = transaction;
        
        // 发送数据给服务器验证
        
    }else{
        
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"验证购买失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
        [alerView show];
        [alerView release];
    }
***/
    
}

// 验证收据
//-(BOOL)putStringToItunes:(NSData*)iapData
//{

//    NSString*encodingStr = [iapData base64EncodedString];
//    string str = [encodingStr UTF8String];
//    Json::Value Receiptstr = Value(str);
//    GAME_SIMULATOR->sendActionRequest(c2c_iap_check_receipt, &Receiptstr,NULL);
//    
//    return true;
    
    /***
     **以下是客户端验证收据，暂不需要
    
     NSString*encodingStr = [iapData base64EncodedString];
    
     NSString *URL=@"https://sandbox.itunes.apple.com/verifyReceipt";
     //https://buy.itunes.apple.com/verifyReceipt
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:URL]];
     [request setHTTPMethod:@"POST"];
     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:[NSString stringWithFormat:@"%d", [encodingStr length]] forHTTPHeaderField:@"Content-Length"];
     
     NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
     SBJsonWriter *writer = [SBJsonWriter new];
     [request setHTTPBody:[[writer stringWithObject:body] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
     NSHTTPURLResponse *urlResponse=nil;
     NSError *errorr=nil;
     NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
     returningResponse:&urlResponse
     error:&errorr];
     
     
     string str = [[writer stringWithObject:body] UTF8String];
     Json::Value Receiptstr = Value(str);
     GAME_SIMULATOR->sendActionRequest(c2c_iap_check_receipt, &Receiptstr,NULL);
    
     //解析
     NSString *results=[[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
     NSLog(@"收据验证:%@",results);
     NSDictionary*dic = [results JSONValue];
     if([[dic objectForKey:@"status"] intValue]==0){
     return true;
     }
     return false;
     
     */
//}



- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//    Json::Value result_ = Value(true);
//    GAME_SIMULATOR->sendActionRequest(c2c_iap_buy_products, &result_,NULL);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSString *str = @"购买失败!";
    
    switch (transaction.error.code)
    {
        case SKErrorUnknown:
            str = @"购买失败,未知错误!";
            NSLog(@"error.code = SKErrorUnknown");
            break;
        case SKErrorClientInvalid:
            str = @"购买失败,客户拒绝购买请求!";
            NSLog(@"error.code = SKErrorClientInvalid , client is not allowed to issue the request, etc.");
            break;
        case SKErrorPaymentCancelled:
            str = @"购买失败,用户取消请求!";
            NSLog(@"error.code = SKErrorPaymentCancelled , user cancelled the request, etc.");
            break;
        case SKErrorPaymentInvalid:
            str = @"购买失败,购买产品无效!";
            NSLog(@"error.code = SKErrorPaymentInvalid , purchase identifier was invalid, etc.");
            break;
        case SKErrorPaymentNotAllowed:
            str = @"购买失败,该设备不允许购买!";
            NSLog(@"error.code = SKErrorPaymentNotAllowed , this device is not allowed to make the payment");
            break;
        case SKErrorStoreProductNotAvailable:
            str = @"购买失败,购买产品不存在!";
            NSLog(@"error.code = SKErrorStoreProductNotAvailable , Product is not available in the current storefront");
            break;
        default:
            break;
    }
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:str
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
    [alerView show];
//    [alerView release];

//    Json::Value result_ = Value(true);
//    GAME_SIMULATOR->sendActionRequest(c2c_iap_buy_products, &result_,NULL);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)comfireTransactions:(bool)isSuessPosted
{
    if ( isSuessPosted ) {
        [[SKPaymentQueue defaultQueue] finishTransaction: curTransaction];
    }
    
    isRequestedBuy = NO;
    
    if (payArray != nil) {
        [payArray removeObject:curTransaction];
    }

}


-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    sharedController = nil;
//    [payArray release];
//    [super dealloc];
}

- (void)checkReceiptIsFail
{
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"购买验证失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
    [alerView show];
//    [alerView release];
}


- (void)addItemToPayArray:(SKPaymentTransaction *)transaction
{
    if ( payArray == nil ) {
        payArray = [NSMutableArray arrayWithCapacity:1];
//        [payArray retain];
    }
    
    [payArray addObject:transaction];
}


- (bool)checkPayArrayIsEmpty
{
    if (payArray == nil) {
        return YES;
    }
    
    if ([payArray count] == 0)
    {
        return YES;
    }
    
    [self checkReceiptForArray];
    return NO;
}


- (void)checkReceiptForArray
{
    if ([payArray count] == 0)
    {
        return;
    }
    
    SKPaymentTransaction *transaction = [payArray lastObject];
    curTransaction = transaction;
    
    // 验证
//    [self putStringToItunes:[transaction transactionReceipt]];
}

@end
//#endif
