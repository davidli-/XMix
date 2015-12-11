//
//  TLVerResultEntity.h
//  VersionHelper
//
//  Created by davidli on 15/9/23.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLVerResultEntity : NSObject

@property (nonatomic, copy) NSString *version;     //版本号（build号）
@property (nonatomic, copy) NSString *downLoadUrl; //下载链接
@property (nonatomic, copy) NSString *updateDes;   //更新日志描述

@property (nonatomic, strong) NSError *error;      //错误信息

@end
