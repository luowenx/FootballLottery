//
//  LQAnalysisProtocol.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LQDecode <NSObject>
@required
/**
 数据解析解析-解析转对象
 
 @param dic json字典
 @return 实例对象json
 */
-(id)initWith:(NSDictionary*)dic;

@end

@protocol LQEncode <NSObject>
@required
/**
 数据解析解析-逆向解析转字典
 
 @return json字典
 */
-(NSDictionary*)toJSON;

@end

@protocol LQDataTransformation <NSObject>
@required

/**
 字典数组转对象数组

 @param dics 字典数组
 @return 对象数组
 */
+ (NSArray *)objArrayWithDics:(NSArray<NSDictionary*>*)dics;

@end

#pragma mark LQParserProtocol
#ifdef c__plusplus
extern "c"{
#endif
    
    static inline BOOL lqpIsJsonElementValid(id dic,NSString *key,SEL responstSel)
    {
        if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
        id parm = [(NSDictionary *)dic valueForKey:key];
        if (responstSel  == NULL) {
            if (parm && parm != [NSNull null]) {
                return YES;
            }
        } else {
            if (parm && parm != [NSNull null] && [parm respondsToSelector:responstSel]) {
                return YES;
            }
        }
        return NO;
    }
    
#ifdef c__plusplus
}
#endif

#define LQDataTransformationImplementation \
+(NSArray *)objArrayWithDics:(NSArray<NSDictionary *> *)dics\
{\
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:dics.count];\
    for (NSDictionary *dic in dics) {\
if (![dic isKindOfClass:[NSDictionary class]]) {\
continue;\
}\
        [array safeAddObject:[[self alloc] initWith:dic]];\
    }\
    return array.copy;\
}


#define __stringif(x) @#x
//设置Parameters for protocol
#define __setBaseAttr(aParameters, att) \
if (self.att != 0) { \
[aParameters setObject:@(self.att) forKey:__stringif(att)];\
}

#define __setBaseAttrInsist(aParameters, att) \
[aParameters setObject:@(self.att) forKey:__stringif(att)];\

#define __setObjAttr(aParameters, att) \
if (self.att) { \
[aParameters setObject:self.att forKey:__stringif(att)];\
}

//标记开始parser response data
#define startParser(dic, aobj, class) \
NSDictionary *intdic = dic; class *inobj = aobj;

//解析object对象
#define parserObjAttr(objatt) \
if (lqpIsJsonElementValid(intdic, __stringif(objatt), NULL)) {\
if ([[intdic objectForKey:__stringif(objatt)] isKindOfClass:[NSNumber class]]) {\
inobj.objatt = [[intdic objectForKey:__stringif(objatt)] stringValue];\
}else{\
inobj.objatt = [intdic objectForKey:__stringif(objatt)];\
}\
}

//解析对象属性与词典key不一样的对象字段
#define parserDiffObjAttr(objatt, key) \
if (lqpIsJsonElementValid(intdic, key, NULL)) {\
inobj.objatt = [intdic objectForKey:key];\
}

//解析基础数据类型
#define parserBaseAttr(baseatt, selValue) \
if (lqpIsJsonElementValid(intdic, __stringif(baseatt), @selector(selValue))) {\
inobj.baseatt = [[intdic objectForKey:__stringif(baseatt)] selValue];\
}

//解析对象属性与词典key不一样的基础数据字段
#define parserDiffBaseAttr(baseatt, key, selValue) \
if (lqpIsJsonElementValid(intdic, key, @selector(selValue))) {\
inobj.baseatt = [[intdic objectForKey:key] selValue];\
}
