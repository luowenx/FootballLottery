//
//  NSURLRequest+SSL.h
//  LequSDK
//
//  Created by 许 on 16/12/6.
//  Copyright © 2016年 许. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (SSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
