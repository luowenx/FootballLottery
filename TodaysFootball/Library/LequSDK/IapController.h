//
//  IapController.h
//  mangosanguo
//
//  Created by Gino on 12-11-6.
//  Copyright (c) 2012年 private. All rights reserved.
//
//#if applepay
#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

@interface IapController : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    bool isRequestedBuy;
    SKPaymentTransaction *PayTransaction;
    
    NSMutableArray *payArray;
    SKPaymentTransaction *curTransaction;
}

+ (IapController *)sharedController;
- (id)init;
- (void)removeIt;
- (void)requestProductData;
- (void)requestBuyProduct:(NSString *)identifier;

- (void)requestProductInfoById:(NSString *)str;
- (void)comfireTransactions:(bool)isSuessPosted;
- (void)checkReceiptIsFail;

- (void)addItemToPayArray:(SKPaymentTransaction *)transaction;
- (bool)checkPayArrayIsEmpty;
- (void)checkReceiptForArray;

- (void)setAppleCallBack: (NSString*)url;
@end
//#endif
