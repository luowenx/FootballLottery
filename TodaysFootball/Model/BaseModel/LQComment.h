//
//  LQComment.h
//  TodaysFootball
//
//  Created by lequwuxian1 on 2018/7/24.
//  Copyright © 2018年 lequwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQComment : NSObject<LQDecode, LQDataTransformation>

@property (nonatomic, copy) NSString * commentTime;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * id;

@end
