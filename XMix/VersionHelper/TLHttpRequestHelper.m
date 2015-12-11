//
//  TLHttpRequestHelper.m
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLHttpRequestHelper.h"
#import "TLMutableURLRequest.h"
#import <CommonCrypto/CommonDigest.h>


NSInteger const kDefault_timeout    =  60;

@implementation TLHttpRequestHelper


#pragma mark - 属性

-(NSMutableDictionary *)mConectionPool{
    if (!_mConectionPool) {
        _mConectionPool = [NSMutableDictionary dictionary];
    }
    
    return _mConectionPool;
}


- (NSMutableDictionary *)mHttpDataPool{
    if (!_mHttpDataPool) {
        
        _mHttpDataPool = [NSMutableDictionary dictionary];
    }
    return _mHttpDataPool;
}


#pragma mark -http connection代理
//收到响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSString *urlKey = [TLHttpRequestHelper makeUrlKey:connection.originalRequest];
    NSString *key = self.mConectionPool[urlKey];
    if (HTTP_IS_GOODRESPONSE(response)) {
        [self.mHttpDataPool setValue:[NSMutableData data] forKey:urlKey];
    }else{
        if ([_delegate respondsToSelector:@selector(httpRequestHelper:onHttpReqFailedWithError:reqKey:)]) {
            NSInteger status = [((NSHTTPURLResponse *)response) statusCode];
            NSError *error = [[NSError alloc] initWithDomain:key code:status userInfo:nil];
            [_delegate httpRequestHelper:self onHttpReqFailedWithError:error reqKey:key];
        }
        [self cancelConnection:connection];
    }
}


//接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString *urlKey = [TLHttpRequestHelper makeUrlKey:connection.originalRequest];
    NSMutableData *mData = [self.mHttpDataPool valueForKey:urlKey];
    if (!mData) {
        mData = [NSMutableData data];
    }
    [mData appendData:data];
    [self.mHttpDataPool setValue:mData forKey:urlKey];
}


//请求结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *urlKey = [TLHttpRequestHelper makeUrlKey:connection.originalRequest];
    NSString *key = self.mConectionPool[urlKey];

    NSError *mError;
    NSMutableData *resultData = [self.mHttpDataPool valueForKey:urlKey];
    NSDictionary *mDic = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&mError];
    
    TraceS(@"+++connectionDidFinishLoading 数据:\n%@ ",mDic);
    
    if ([_delegate respondsToSelector:@selector(httpRequestHelper:onHttpReqFinishedWithData:reqKey:)]) {
        [_delegate httpRequestHelper:self onHttpReqFinishedWithData:mDic reqKey:key];
    }
    
    [self.mConectionPool setValue:nil forKey:urlKey];
    [self.mHttpDataPool setValue:nil forKey:urlKey];
}


//请求出错
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSString *urlKey = [TLHttpRequestHelper makeUrlKey:connection.originalRequest];
    NSString *key = self.mConectionPool[urlKey];

    if ([_delegate respondsToSelector:@selector(httpRequestHelper:onHttpReqFailedWithError:reqKey:)]) {
        NSError *error = [[NSError alloc] initWithDomain:key code:-1001 userInfo:nil];
        [_delegate httpRequestHelper:self onHttpReqFailedWithError:error reqKey:key];
    }
    [self cancelConnection:connection];
}




#pragma mark -方法

- (NSURLConnection*)sendRequest:(NSString*)api body:(NSString*)body reqType:(NSString*)type connectionPoolKey:(NSString*)key{
    
    TLMutableURLRequest *request;
    NSString *urlStr;
    NSURL *url;
    
    if (0 == body.length) {
        body = @"";
    }
    
    if ([GET isEqualToString:type]) { //Get方法 参数包含在链接域名中
        urlStr  = [api stringByAppendingString:body];
        url     = [NSURL URLWithString:urlStr];
        request = [[TLMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kDefault_timeout];
    }
    else{ //POST方法 参数通过request的body传递
        urlStr = api;
        url    = [NSURL URLWithString:urlStr];
        request = [[TLMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kDefault_timeout];
        //设置报文
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    }
    
    [request setHTTPMethod:type];
    
    //缓存此次请求
    if (key && 1 <= key.length) {
        [self cacheConnection:request forKey:key];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    dispatch_queue_t queue = dispatch_queue_create("taole.version", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [connection start];
    });
    
    return connection;
}



#pragma mark -辅助方法

- (void)cancelConnection:(NSURLConnection*)connection
{
    if (!connection)
    {
        return;
    }
    [connection cancel];
    [self.mHttpDataPool setValue:nil forKey:[TLHttpRequestHelper makeUrlKey:connection.originalRequest]];
}


- (void)cacheConnection:(TLMutableURLRequest*)request forKey:(NSString*)key
{
    if (request) {
        [self.mConectionPool setValue:key forKey:[TLHttpRequestHelper makeUrlKey:request]];
    }
}


//计算key
+ (NSString *)makeUrlKey:(NSURLRequest *)request
{
    NSString *key = nil;
    
    if ([request respondsToSelector:@selector(uniqueKey)]) {
        key = [request performSelector:@selector(uniqueKey)];
    }
    else
    {
        key = [self md5:[request.URL absoluteString]];
        key = [key stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)request.hash]];
    }
    
    return key;
}


//MD5加密
+ (NSString*) md5:(NSString*)str{
    if (!str || 0 == str.length) {
        return nil;
    }
    
    const char *md5Str = [str UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5Str, (CC_LONG)strlen(md5Str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}


@end
