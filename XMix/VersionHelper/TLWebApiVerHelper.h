//
//  TLWebApiVerHelper.h
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLVersionHelper.h"

@interface TLWebApiVerHelper : TLVersionHelper

#pragma mark -接口
/**
 *  使用web提供的api 获取应用版本号 参数中api为必传 （静态ip）
 *
 *  @param verEntity
 */
- (void)reqWebApiVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate;

@end
