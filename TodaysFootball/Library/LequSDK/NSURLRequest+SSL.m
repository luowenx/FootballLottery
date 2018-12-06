//
//  NSURLRequest+SSL.m
//  LequSDK
//
//  Created by 许 on 16/12/6.
//  Copyright © 2016年 许. All rights reserved.
//

#import "NSURLRequest+SSL.h"

@implementation NSURLRequest (SSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
}
@end
