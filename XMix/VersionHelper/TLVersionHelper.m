//
//  TLVersionHelper.m
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLVersionHelper.h"
#import "TLFirVersionHelper.h"
#import "TLDandelionVerHelper.h"
#import "TLWebApiVerHelper.h"

@interface TLVersionHelper()

@property (nonatomic, strong) TLFirVersionHelper   *mFirVerHelper;
@property (nonatomic, strong) TLDandelionVerHelper *mDanVerHelper;
@property (nonatomic, strong) TLWebApiVerHelper    *mWebVerHelper;

@end

@implementation TLVersionHelper

#pragma mark -属性

-(TLHttpRequestHelper *)mReqHelper{
    if (!_mReqHelper) {
        _mReqHelper = [TLHttpRequestHelper new];
    }
    return _mReqHelper;
}


-(TLFirVersionHelper *)mFirReqHelper{
    if (!_mFirVerHelper) {
        _mFirVerHelper = [TLFirVersionHelper new];
    }
    return _mFirVerHelper;
}


-(TLDandelionVerHelper *)mDanVerHelper{
    if (!_mDanVerHelper) {
        _mDanVerHelper = [TLDandelionVerHelper new];
    }
    return _mDanVerHelper;
}


-(TLWebApiVerHelper *)mWebVerHelper{
    if (!_mWebVerHelper) {
        _mWebVerHelper = [TLWebApiVerHelper new];
    }
    return _mWebVerHelper;
}



#pragma mark -发送请求
- (void)httpReqVersionWithEntity:(TLVerRequestEntity*)versionEntity delegate:(id<TLVersionHelperProtocol>)delegate{
        
    VERSION_TARGET target = versionEntity.target;
    
    if (VERSION_TARGET_FIR == target) {
        [self.mFirReqHelper reqFirVersion:versionEntity delegate:delegate];
        
    }else if (VERSION_TARGET_DANDELION == target){
        [self.mDanVerHelper reqDandelionVersion:versionEntity delegate:delegate];
        
    }else if (VERSION_TARGET_TAOLE == target){
        [self.mWebVerHelper reqWebApiVersion:versionEntity delegate:delegate];
    }
}



#pragma mark -工具方法

+ (NSInteger)compareVersion:(NSString*) version1 withVersion:(NSString*)version2{
    
    NSArray *curArr = [version1 componentsSeparatedByString:@"."];
    NSArray *serArr = [version2 componentsSeparatedByString:@"."];
    
    NSInteger countCur = [curArr count];
    NSInteger countSer = [serArr count];
    NSInteger numT = 0;
    
    if (countCur==countSer) {//版本号位数相同
        for (NSInteger i=0; i < countCur; i++) {
            
            if (numT == 0) {
                if ([curArr[i] intValue] < [serArr[i] intValue]) {
                    return -1;//上一位A<B 直接返回-1
                }else if ([curArr[i] intValue] == [serArr[i] intValue]) {
                    numT = 0;//上一位A=B 接着比下一位
                }else{
                    return 1;//上一位 A>B 直接返回1
                }
            }else if (numT == -1){
                return -1;
            }else{
                return 1;
            }
        }
        return numT;
    }
    else{//版本号位数不相同
        NSInteger count = MIN(countCur, countSer);
        for (NSInteger i=0; i < count; i++) {
            
            if (numT == 0) {                                     //上一位A=B 接着比下一位
                if ([curArr[i] intValue] < [serArr[i] intValue]) {//上一位A<B 直接返回-1
                    return -1;
                }else if ([curArr[i] intValue] == [serArr[i] intValue]) {//上一位A=B 接着比下一位
                    numT = 0;
                }else{                                            //上一位 A>B 直接返回1
                    return 1;
                }
            }else if (numT == -1){
                return -1;
            }else{
                return 1;
            }
        }
        
        //count比对完了 还没区分出大小  则再向下取数字对比
        if (count==countCur) {
            for (int m = 0; m < (countSer-count); m++) {
                
                if (0 < [serArr[count+m] intValue]) {
                    numT = -1;
                }else if (0 == [serArr[count+m] intValue]){
                    return 0;
                }else{
                    return 1;
                }
            }
        }
        else{
            for (NSInteger m = 0; m < (countCur-count); m++) {
                if (0 < [curArr[count+m] intValue]) {
                    numT = 1;
                }else if (0 == [curArr[count+m] intValue]){
                    return 0;
                }else{
                    return -1;
                }
            }
        }
        return numT;
    }
}

@end
