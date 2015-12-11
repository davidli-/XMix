//
//  TLHttpRequestDelegate.h
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#ifndef VersionHelper_TLHttpRequestDelegate_h
#define VersionHelper_TLHttpRequestDelegate_h

@class TLHttpRequestHelper;

@protocol TLHttpRequestDelegate <NSObject>

/**
 *  请求成功回调
 *
 *  @param requestHelper requestHelper
 *  @param data          接口数据
 *  @param key           请求的标识
 */
- (void)httpRequestHelper:(TLHttpRequestHelper*)requestHelper onHttpReqFinishedWithData:(id)data reqKey:(NSString*)key;


/**
 *  请求失败回调 如Apache错误或接口本身问题
 *
 *  @param requestHelper requestHelper
 *  @param error         错误信息
 *  @param key           请求的标识
 */
- (void)httpRequestHelper:(TLHttpRequestHelper*)requestHelper onHttpReqFailedWithError:(id)error reqKey:(NSString*)key;

@end

#endif
