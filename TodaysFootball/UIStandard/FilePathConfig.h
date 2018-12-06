//
//  FilePathConfig.h
//  haochang
//
//  Created by Administrator on 15-1-19.
//  Copyright (c) 2015年 Administrator. All rights reserved.
//

#ifndef FilePathConfig_h
#define FilePathConfig_h

//-------------------文件存储路径 begin-------------------
#define PathDocuments       [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define PathLibrary         [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define PathTemp            [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define PathPreferences     [PathLibrary stringByAppendingPathComponent:@"Preferences"]
#define PathCaches          [PathLibrary stringByAppendingPathComponent:@"Caches"]

//用户信息
#define kLQPathWithUserInfo  [PathPreferences stringByAppendingPathComponent:@"kLQPathWithUserInfo"]

// 应用信息
#define kLQPathWithAppConfiger  [PathPreferences stringByAppendingPathComponent:@"kLQPathWithAppConfiger"]


#endif
