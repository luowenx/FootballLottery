//
//  LQFLmacro.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#ifndef LQFLmacro_h
#define LQFLmacro_h

typedef void (^MCBlockVoid)(void);
typedef void (^MCBlockParam)(id aParam);
typedef void (^MCBlockBool)(BOOL isTrue);
typedef void (^MCBlockInt)(int index);

#define stringNotNil(str) (str ? [NSString stringWithFormat:@"%@",str] : @"")

//缓存图片,调用系统缓存临时存取~ 频繁使用的图片并且是小图则使用该方法加载图片
#define imageWithName(_name)    [UIImage imageNamed:_name]
#define imageNoCacheWithName(__name, __type) [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], __name, __type]]

#define is_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f)

#define kLQNavHeight (44)

#define kLQTabarHeight (is_iPhoneX? 83:49)

#define kLQSafeBottomHeight (is_iPhoneX?34:0)

#define kLQStatusBarHeight (is_iPhoneX ? 44:20)

#define kLQNavANDStatusBarHeight (kLQNavHeight + kLQStatusBarHeight)

#define UIDeviceScreenSize   [[UIScreen mainScreen] bounds].size
#define UIDeviceScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define UIDeviceScreenHeight [[UIScreen mainScreen] bounds].size.height

#define IOS8_OR_EARLIER        ( !IOS9_OR_LATER )
#define IOS7_OR_EARLIER        ( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER        ( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER        ( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER        ( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER        ( !IOS4_OR_LATER )

#define IOS10_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS9_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS8_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS7_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS6_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS5_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS4_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS3_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"3.0" options:NSNumericSearch] != NSOrderedAscending )

/**
 *  是否是iPhone6的屏幕
 */
#define mt_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone6_Plus的屏幕
 */
#define mt_iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone4的屏幕
 */
#define mt_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone5的屏幕
 */
#define mt_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* LQFLmacro_h */

//对象类型
#define SYNTHESIZE_CATEGORY_OBJ_PROPERTY(propertyGetter, propertySetter)\
- (id) propertyGetter {\
return objc_getAssociatedObject(self, @selector( propertyGetter ));\
}\
- (void) propertySetter (id)obj{\
objc_setAssociatedObject(self, @selector( propertyGetter ), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

//基本类型
#define SYNTHESIZE_CATEGORY_VALUE_PROPERTY(valueType, propertyGetter, propertySetter)\
- (valueType) propertyGetter {\
valueType ret = {0};\
[objc_getAssociatedObject(self, @selector( propertyGetter )) getValue:&ret];\
return ret;\
}\
- (void) propertySetter (valueType)value{\
NSValue *valueObj = [NSValue valueWithBytes:&value objCType:@encode(valueType)];\
objc_setAssociatedObject(self, @selector( propertyGetter ), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// block 安全self
#if __has_feature(objc_arc)
// arc
#define WEAKSELF        typeof(self) __weak weakSelf = self
#define STRONGSELF      typeof(weakSelf) __strong strongSelf = weakSelf
#else
// mrc
#define WEAKSELF     __block typeof(id) weakSelf = self;
#define WEAKSELF_( __CLASSNAME__ )     __block typeof( __CLASSNAME__ *) weakSelf = self;
#endif
