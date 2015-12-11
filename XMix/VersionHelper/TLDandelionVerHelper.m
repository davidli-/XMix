//
//  TLDandelionVerHelper.m
//  VersionHelper
//
//  Created by davidli on 15/9/22.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLDandelionVerHelper.h"
#import "TLHttpRequestHelper.h"

NSString *const kDefaultDownloadDomain   =  @"http://www.pgyer.com/apiv1/app/install";

@interface TLDandelionVerHelper()<TLHttpRequestDelegate>

@property (nonatomic, strong) TLVerRequestEntity *mVerEntity;
@property (nonatomic, strong) NSURLConnection *mVerConnection;
@property (nonatomic, weak) id<TLVersionHelperProtocol>delegate;

@end


@implementation TLDandelionVerHelper

#pragma mark - TLHttpRequestDelegate

-(void)httpRequestHelper:(TLHttpRequestHelper *)requestHelper onHttpReqFinishedWithData:(id)data reqKey:(NSString *)key{
    
    NSDictionary *dic = data;
    TLVerResultEntity *resultEntity = [TLVerResultEntity new];
    if (dic) {
        NSDictionary *appDic;
        NSArray *appGroupArr = dic[@"data"];
        NSInteger count = appGroupArr.count;
        for (NSInteger i = 0; i < count; i++) {
            NSDictionary *appDicTmp = appGroupArr[i];
            BOOL isLatest = [appDicTmp[@"appIsLastest"] boolValue];
            if (isLatest) {
                appDic = appDicTmp;
                break;
            }
        }
        
        if (appDic) {
            NSString *appKey         = appDic[@"appKey"];
            resultEntity.version     = appDic[@"appVersion"];
            resultEntity.updateDes   = appDic[@"appUpdateDescription"];
            resultEntity.downLoadUrl = [NSString stringWithFormat:@"%@?_api_key=%@&aKey=%@",kDefaultDownloadDomain,_mVerEntity.apiKey,appKey];
            
            //版本号请求完成 回调回去
            if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
                [_delegate versionHelper:self onFinishedWithResult:resultEntity];
            }
            return;
        }
    }
    
    NSError *error = [NSError errorWithDomain:key code:-1001 userInfo:nil];
    resultEntity.error = error;
    if ([_delegate respondsToSelector:@selector(versionHelper:onFinishedWithResult:)]) {
        [_delegate versionHelper:self onFinishedWithResult:resultEntity];
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

- (void)reqDandelionVersion:(TLVerRequestEntity*)verEntity delegate:(id<TLVersionHelperProtocol>)delegate{
    self.mReqHelper.delegate = self;
    
    _mVerEntity = verEntity;
    _delegate = delegate;
    
    NSString *api, *appID, *apikey;
    api    = verEntity.api;
    appID  = verEntity.appID;
    apikey = verEntity.apiKey;
    
    if (_mVerConnection) {
        [self.mReqHelper cancelConnection:_mVerConnection];
    }
    
    NSString *body = [NSString stringWithFormat:@"aId=%@&_api_key=%@",appID,apikey];
    
    _mVerConnection = [self.mReqHelper sendRequest:api body:body reqType:POST connectionPoolKey:HttpDanGetVer];
}

@end
