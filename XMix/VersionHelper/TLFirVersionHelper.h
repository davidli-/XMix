//
//  TLFirVersionHelper.h
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLVersionHelper.h"

@interface TLFirVersionHelper : TLVersionHelper

#pragma mark -接口

/**
 *  获取FIR上的版本号 其中appID token api为必传
 *
 *  @param verEntity
 */
- (void)reqFirVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate;

@end
