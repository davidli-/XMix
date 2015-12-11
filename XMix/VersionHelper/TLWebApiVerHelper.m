//
//  TLWebApiVerHelper.m
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLWebApiVerHelper.h"
#import "TLHttpRequestHelper.h"

@interface TLWebApiVerHelper()<TLHttpRequestDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, weak) id<TLVersionHelperProtocol>delegate;

@end

@implementation TLWebApiVerHelper

#pragma mark -TLHttpRequestDelegate

-(void)httpRequestHelper:(TLHttpRequestHelper *)requestHelper onHttpReqFinishedWithData:(id)data reqKey:(NSString *)key{
    NSDictionary *dic = data;
    
    TLVerResultEntity *resultEntity = [TLVerResultEntity new];
    if (dic) {
        NSInteger retCode = [dic[@"retCode"] integerValue];
        if (0 == retCode) {
            NSDictionary *innerDic = dic[@"retData"];
            resultEntity.version     = innerDic[@"version"];
            resultEntity.downLoadUrl = innerDic[@"url"];
            resultEntity.updateDes   = innerDic[@"description"];
            
            if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
                [_delegate versionHelper:self onFinishedWithResult:resultEntity];
            }
        }else{
            NSError *error = [NSError errorWithDomain:key code:retCode userInfo:nil];
            resultEntity.error = error;
            if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
                [_delegate versionHelper:self onFinishedWithResult:resultEntity];
            }
        }
    }
    else{
        NSError *error = [NSError errorWithDomain:key code:-1001 userInfo:nil];
        resultEntity.error = error;
        if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
            [_delegate versionHelper:self onFinishedWithResult:resultEntity];
        }
    }
}


-(void)httpRequestHelper:(TLHttpRequestHelper *)requestHelper onHttpReqFailedWithError:(id)error reqKey:(NSString *)key{
    TLVerResultEntity *resultEntity = [TLVerResultEntity new];
    resultEntity.error = error;
    if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
        [_delegate versionHelper:self onFinishedWithResult:resultEntity];
    }
}


#pragma mark - 请求接口
- (void)reqWebApiVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate{
    self.mReqHelper.delegate = self;
    _delegate = delegate;
    
    if (_connection) {
        [self.mReqHelper cancelConnection:_connection];
    }
    NSString *body;
    NSString *staticApi = verEntity.api;
    if (staticApi) {
        body = @"type=ios";
    }
    
    _connection = [self.mReqHelper sendRequest:staticApi body:body reqType:POST connectionPoolKey:HttpApiGetVer];
}


@end
