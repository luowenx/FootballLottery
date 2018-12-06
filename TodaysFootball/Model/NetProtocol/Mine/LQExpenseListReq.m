//
//  LQExpenseListReq.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQExpenseListReq.h"

@implementation LQExpenseListReq

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relativeUrl = @"/api/wallets/expenseList/";
        self.method = BAHttpRequestTypeGet;
    }
    return self;
}

-(LQNetResponse *)httpResponseParserData:(id)aData
{
    LQExpenseListRes *res = [[LQExpenseListRes alloc] initWith:aData];
    startParser(res.data, res, LQExpenseListRes)
    parserBaseAttr(colorbean, integerValue)
    if (lqpIsJsonElementValid(intdic, @"expenseList", NULL)) {
        inobj.expenseList = intdic[@"expenseList"];
    }
    
    return res;
}

@end

@implementation LQExpenseListRes

@end
