//
//  TLHttpRequestHelper.h
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLHttpRequestDelegate.h"
#import "TLHttpParams.h"

#define POST  @"POST"
#define GET   @"GET"

#define HTTP_IS_GOODRESPONSE(response) (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)

@interface TLHttpRequestHelper : NSObject<NSURLConnectionDataDelegate>

#pragma mark -属性
@property (nonatomic, weak) id<TLHttpRequestDelegate>delegate;  //请求回来之后的回调 自己处理请求结果

@property (nonatomic, strong) NSMutableDictionary *mConectionPool; // 保存请求
@property (nonatomic, strong) NSMutableDictionary *mHttpDataPool;  //保存请求的数据


#pragma mark -接口

/**
 *  取消请求
 *
 *  @param connection
 */
- (void)cancelConnection:(NSURLConnection*)connection;


/**
 *  发送请求 fir传完整的链接  蒲公英和api只传域名 参数通过post设置在请求的body报文中
 *
 *  @param api  请求域名 fir传完整的链接  蒲公英和api只传域名
 *  @param body 参数字符串
 *  @param type POST\GET 其中fir使用GET 蒲公英和api使用POST
 *  @param key  请求标识
 *
 *  @return
 */
- (NSURLConnection*)sendRequest:(NSString*)api body:(NSString*)body reqType:(NSString*)type connectionPoolKey:(NSString*)key;

+ (NSString *)makeUrlKey:(NSURLRequest *)request;

@end
