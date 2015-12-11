//
//  TLFirVersionHelper.m
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLFirVersionHelper.h"
#import "TLHttpRequestHelper.h"

@interface TLFirVersionHelper()<TLHttpRequestDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, weak) id<TLVersionHelperProtocol>delegate;

@end

@implementation TLFirVersionHelper

#pragma mark - TLHttpRequestDelegate
-(void)httpRequestHelper:(TLHttpRequestHelper *)requestHelper onHttpReqFinishedWithData:(id)data reqKey:(NSString *)key{
    NSDictionary *dic = data;
    
    TLVerResultEntity *resultEntity = [TLVerResultEntity new];
    
    if (dic) {
        resultEntity.version     = [NSString stringWithFormat:@"%@",dic[@"build"]];
        resultEntity.downLoadUrl = [NSString stringWithFormat:@"%@",dic[@"update_url"]];
        resultEntity.updateDes   = [NSString stringWithFormat:@"%@",dic[@"changelog"]];
        
        if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
            [_delegate versionHelper:self onFinishedWithResult:resultEntity];
        }
    }
    else{
        NSError *error = [NSError errorWithDomain:HttpFirGetVer code:-1001 userInfo:nil];
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
- (void)reqFirVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate{
    
    self.mReqHelper.delegate = self;
    _delegate = delegate;
    
    if (_connection) {
        [self.mReqHelper cancelConnection:_connection];
    }
    
    NSString *api, *appID, *token, *urlStr;
    
    api = verEntity.api;
    appID = verEntity.appID;
    token = verEntity.apiKey;
    
    urlStr = [NSString stringWithFormat:@"%@%@?api_token=%@",api,appID,token];
    
    _connection = [self.mReqHelper sendRequest:urlStr body:nil reqType:GET connectionPoolKey:HttpFirGetVer];
}

@end
