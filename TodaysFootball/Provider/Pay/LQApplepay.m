//
//  LQApplepay.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQApplepay.h"
#import "LQProduct.h"

#import "LQTradeReq.h"
#import "LQPayReportReq.h"

#import <StoreKit/StoreKit.h>

static NSString *const kPlistName = @"LQApplepay.plist"; // 缓存订单文件名

static NSString *const kAppleReceiptKey = @"kAppleReceiptKey"; // 缓存凭证key
static NSString *const kAppleTransactionIdKey = @"kAppleTransactionIdKey"; // 缓存苹果交易id key

@interface LQApplepay ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, copy) LQPayCallBack callBack;
@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSMutableDictionary *trades; // 未上传的订单

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LQApplepay
@synthesize product;

+ (instancetype)defaultPay {
    static LQApplepay *provider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provider = [[super allocWithZone:NULL] init];
    });
    return provider;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LQApplepay defaultPay];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [LQApplepay defaultPay];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trades = [NSMutableDictionary dictionary];

        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                      target:self
                                                    selector:@selector(timerAction)
                                                    userInfo:nil
                                                     repeats:YES];
        [self pauseTimer];
    }
    return self;
}

- (void)cancelProductsRequest {
    [self.request cancel];
    self.request.delegate = nil;
    self.request = nil;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self deleteTimer];
}

+(BOOL)canPay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)payCallBack:(LQPayCallBack)callBack
{
    self.callBack = callBack;
    
    NSAssert(self.product.productId.length > 0, @"Maybe you must give me a product !!!");
    
    if (![[self class] canPay]) {
        self.callBack?self.callBack(NO, kLQPayDelegateTypeUnableToMakePayments):nil;
        return;
    }
    NSArray *product = @[self.product.productId];
    // 8.初始化请求
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:product]];
    self.request.delegate = self;

    // 9.开始请求
    [self.request start];
    self.callBack?self.callBack(NO, kLQPayDelegateTypeWillRequestProductInfo):nil;
}

- (void)startReportCache
{
    [self localCacheTrades];
    [self startTimer];
}

- (void)timerAction {
    // 开始提交订单
    if (self.trades.count > 0) {
        for (NSString *tranId in self.trades) {
            NSDictionary *dic = self.trades[tranId];
            [self submitTradeWithReceipt:dic[kAppleReceiptKey] appleTransactionId:dic[kAppleTransactionIdKey] transactionId:tranId completion:nil] ;
        }
    } else {
        [self pauseTimer];
    }
}

#pragma mark 定时器
- (void)startTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate date]];
    }
}

- (void)pauseTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)deleteTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 订单缓存
// 本地缓存路径
- (NSString *)cachePath {
    static NSString *path;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:kPlistName];
    });
    return path;
}

// 获取本地缓存未提交订单信息
- (void)localCacheTrades {
    NSDictionary *trades = [NSDictionary dictionaryWithContentsOfFile:[self cachePath]];
    [self.trades removeAllObjects];
    [self.trades addEntriesFromDictionary:trades];
}

// 缓存订单信息
- (void)saveTradeWithReceipt:(NSString *)receipt appleTransactionId:(NSString *)aid transactionId:(NSString *)tid {
    if (self.trades && receipt && tid && aid) {
        [self.trades setObject:@{kAppleReceiptKey: receipt, kAppleTransactionIdKey: aid} forKey:tid];
        [self.trades writeToFile:[self cachePath] atomically:YES];
    }
}

// 删除订单信息
- (void)deleteTradeWithTransacationId:(NSString *)tid {
    if (self.trades && tid) {
        [self.trades removeObjectForKey:tid];
        [self.trades writeToFile:[self cachePath] atomically:YES];
    }
}

#pragma mark ====  private
// 在我们自己的服务器生成订单
- (void)createTradeWithCompletion:(void (^)(BOOL finish, NSString *transacationId))completion {
    
    LQTradeReq *req = [[LQTradeReq alloc] init];
    [req requestWithCompletion:^(id response) {
        LQTradeRes *res = (LQTradeRes *)response;
        if (res.ret == kLQNetResponseSuccess) {
            if (completion) completion(YES, res.iapOrderId);
        }else{
            if (completion) completion(NO, nil);
        }
    } error:^(NSError *error) {
        if (completion) completion(NO, nil);
    }];
}

// 提交订单信息
- (void)submitTradeWithReceipt:(NSString *)receipt appleTransactionId:(NSString *)aid transactionId:(NSString *)tid completion:(void (^)(BOOL finish))completion {
    // 接口上报支付接口
    LQPayReportReq *req = [[LQPayReportReq alloc] init];
    req.iapOrderId = tid;
    req.data = receipt;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse*)response;
        if (res.ret == kLQNetResponseSuccess) {
            // 保存返回的用户信息
            LQUserInfo *user = [[LQUserInfo alloc] initWith:res.data];
            userManager.currentUser = user;
            [userManager saveCurrentUser];
            
            if (completion) completion(YES);
            // 删除本地需要上报的缓存
            [self deleteTradeWithTransacationId:tid];
        }else if(res.ret == kLQNetResponseOrderCheckFailed){ // 校验失败，但无需再校验了
            if (completion) completion(NO);
            [self deleteTradeWithTransacationId:tid];
        }else{
            if (completion) completion(NO);
        }
    } error:^(NSError *error) {
        if (completion) completion(NO);
    }];
}

- (void)completeWithPaymentTransaction:(SKPaymentTransaction *)transaction
{
    // 从沙盒中获取交易凭证
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    // 转化为base64字符串
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    // 事务id
    NSString *tid = transaction.payment.applicationUsername ? transaction.payment.applicationUsername : [NSString stringWithFormat:@"%@_%@", @"iapOrderIdNULL", @([NSDate date].timeIntervalSince1970)];
    // 苹果订单号
    NSString *aid = transaction.transactionIdentifier;
    
    if (receiptString) {
        // 支付成功
        self.callBack?self.callBack(YES, kLQPayDelegateTypePaySuccess):nil;
        [self saveTradeWithReceipt:receiptString appleTransactionId:aid transactionId:tid];
        
        [self submitTradeWithReceipt:receiptString appleTransactionId:aid transactionId:tid completion:^(BOOL finish) {
            
            if (finish) {
                self.callBack?self.callBack(YES, kLQPayDelegateTypeConfirmOrderSuccess):nil;
            }else{
                self.callBack?self.callBack(NO, kLQPayDelegateTypeConfirmOrderFailure):nil;
                // 开启订单自动校验
                [self startReportCache];
            }
        }];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }else{
        // 支付失败
        self.callBack?self.callBack(NO, kLQPayDelegateTypePayFailure):nil;
    }

}

// 支付失败
- (void)failedWithPaymentTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // 失败
        self.callBack?self.callBack(NO, kLQPayDelegateTypePayFailure):nil;
    } else {
        // 取消
        self.callBack?self.callBack(NO, kLQPayDelegateTypePayCanceled):nil;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreWithPaymentTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark  ===   SKProductsRequestDelegate
// 10.接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    //如果服务器没有产品
    if([product count] == 0){
        // 商品信息请求失败
        self.callBack?self.callBack(NO, kLQPayDelegateTypeRequestProductInfoFailure):nil;
        return;
    }
    
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:self.product.productId]){
            requestProduct = pro;
        }
    }
    
    if (requestProduct) {
        // 12.发送购买请求
        [self createTradeWithCompletion:^(BOOL finish, NSString *transacationId) {
            if (finish && transacationId.length > 0) { // 开始支付
                self.callBack?self.callBack(YES, kLQPayDelegateTypeRequestProductInfoSuccess):nil;
                SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:requestProduct];
                payment.applicationUsername = transacationId;
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }else{
                // 商品信息请求失败
                self.callBack?self.callBack(NO, kLQPayDelegateTypeRequestProductInfoFailure):nil;
            }
        }];
    }else{
        // 商品信息请求失败
        self.callBack?self.callBack(NO, kLQPayDelegateTypeRequestProductInfoFailure):nil;
    }
    [self cancelProductsRequest];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    // 商品信息获取失败
    self.callBack?self.callBack(NO, kLQPayDelegateTypeRequestProductInfoFailure):nil;
    [self cancelProductsRequest];
}

- (void)requestDidFinish:(SKRequest *)request {
    [self cancelProductsRequest];
}

#pragma mark  ===== SKPaymentTransactionObserver
// 13.监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased: {// 服务器校验
                NSLog(@"交易完成");
                [self completeWithPaymentTransaction:tran];
                break;
            }
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"商品添加进列表");
                break;
            }
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                [self restoreWithPaymentTransaction:tran];
                break;
            }
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [self failedWithPaymentTransaction:tran];
                break;
            }
            default:
                break;
        }
    }
}


@end
