//
//  TLVersionHelper.h
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLVerResultEntity.h"
#import "TLVerRequestEntity.h"
#import "TLHttpRequestHelper.h"

@class TLVersionHelper;

@protocol TLVersionHelperProtocol <NSObject>

- (void)versionHelper:(TLVersionHelper*)versionHelper onFinishedWithResult:(TLVerResultEntity*)resultEntity;

@end

typedef void (^VersionCallback)(NSString *version,NSString *downUrl,NSString *updateDes,NSError *error);



@interface TLVersionHelper : NSObject


#pragma mark -属性
@property (nonatomic, strong) TLHttpRequestHelper *mReqHelper;



#pragma mark -接口
/**
 *  获取平台下 应用的版本号信息 其中FIR时target appID token api为必传；蒲公英时target api apiToken appName为必传；api时 api为必传 （静态ip）
 *
 *  @param versionEntity   平台信息
 *  @param delegate
 */
- (void)httpReqVersionWithEntity:(TLVerRequestEntity*)versionEntity delegate:(id<TLVersionHelperProtocol>)delegate;


/**
 *  版本号对比
 *
 *  @param version1 对象A
 *  @param version2 对象B
 *
 *  @return A版本号与B版本号比对 1表示A>B 0表示相等 -1表示A<B
 */
+ (NSInteger)compareVersion:(NSString*)version1 withVersion:(NSString*)version2;



/*
 *
 示例
 1、FIR
 TLVerRequestEntity *verEntity = [TLVerRequestEntity new];
 verEntity.target = VERSION_TARGET_FIR;
 verEntity.api = @"http://api.fir.im/apps/latest/";
 verEntity.appKey = @"559d29e9692d796672000000";
 verEntity.apiKey = @"efcf537928e98dac9a5e04f79989195a";
 
 //调接口 httpReqVersionWithEntity:() ...
 
 
 2、蒲公英
 
 TLVerRequestEntity *verEntity = [TLVerRequestEntity new];
 verEntity.target = VERSION_TARGET_DANDELION;
 verEntity.api = @"http://www.pgyer.com/apiv1/app/getAppKeyByShortcut";
 verEntity.detailApi = @"http://www.pgyer.com/apiv1/app/view";
 verEntity.apiKey = @"994824468692f7d89ca8308f74c93405";
 verEntity.appName  = @"letao";
 
 //调接口 httpReqVersionWithEntity:() ...
 
 3、web api
 
 乐淘
 TLVerRequestEntity *verEntity = [TLVerRequestEntity new];
 verEntity.target = VERSION_TARGET_TAOLE;
 verEntity.api = @"http://mobile.5dktv.com/api/mapi/version/info.html"; 域名+function
 
 //调接口 httpReqVersionWithEntity:() ...
 
 随播
 TLVerRequestEntity *verEntity = [TLVerRequestEntity new];
 verEntity.target = VERSION_TARGET_TAOLE;
 verEntity.api = @"http://mobile.5dktv.com/api/mapi/version/info.html";
 
 //调接口 httpReqVersionWithEntity:() ...
 
 *
 */


@end
