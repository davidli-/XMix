//
//  TLDandelionVerHelper.h
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLVersionHelper.h"

@interface TLDandelionVerHelper : TLVersionHelper

#pragma mark -接口
/**
 *  获取蒲公英上的应用信息 参数中api apiToken appName为必传
 *
 *  @param verEntity 参数实体
 */
- (void)reqDandelionVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate;

@end
