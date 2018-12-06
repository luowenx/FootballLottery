//
//  LQMatchWebViewModel.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/25.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchWebViewModel.h"

@interface  LQMatchWebViewModel ()
@property (nonatomic) MatchWebViewShowType showType;
@property (nonatomic, copy) NSString * matchInfoId;

@end

@implementation LQMatchWebViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showType = kMatchWebViewShowTypeNone;
    }
    return self;
}



#pragma mark == public
-(void)updateShowType:(MatchWebViewShowType)showType
{
    self.showType = showType;

}

-(void)setMatchId:(NSString *)matchID
{
    _matchInfoId = matchID;
}

-(NSString *)webUrl
{
    switch (self.showType) {
        case kMatchWebViewShowTypeData:
            return [NSString stringWithFormat:@"%@/match/%@/data%@", LQWebURL , self.matchInfoId, LQWebPramSuffix];
            break;
        case kMatchWebViewShowTypeReport:
            return [NSString stringWithFormat:@"%@/match/%@/report%@", LQWebURL, self.matchInfoId, LQWebPramSuffix];
            break;
        case kMatchWebViewShowTypeCompensate:
            return [NSString stringWithFormat:@"%@/match/%@/odds%@", LQWebURL, self.matchInfoId, LQWebPramSuffix];
            break;
        case kMatchWebViewShowTypeTotalScore:
            return [NSString stringWithFormat:@"%@/match/%@/ball%@", LQWebURL, self.matchInfoId, LQWebPramSuffix];
            break;
        case kMatchWebViewShowTypeLive:
            return [NSString stringWithFormat:@"%@/match/%@/live%@", LQWebURL, self.matchInfoId, LQWebPramSuffix];
            break;
        default:
            break;
    }
    return nil;
}

@end
