//
//  LequNotifications.h
//  LequSDK
//
//  Created by 莫 东荣 on 13-4-10.
//  Copyright (c) 2013年 莫 东荣. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LequExitNotification;                  /**<  退出 */
extern NSString * const LequLoginNotification;					/**< 登录完成的通知*/
extern NSString * const LequPaytNotification;                  /**< 支付通知 */
extern NSString * const LequShareNotification;                 /**<  分享通知 */
extern NSString * const LequCenterNotification;                /**<  用户中心通知  */
extern NSString * const LequErrorNotification;                 /**<  出错 */


@interface LequNotifications : NSObject

@end
