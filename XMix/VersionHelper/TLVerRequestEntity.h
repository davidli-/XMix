//
//  TLVerRequestEntity.h
//  VersionHelper
//
//  Created by davidli on 15/9/23.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VERSION_TARGET_FIR  = 1,    //fir上的版本
    VERSION_TARGET_DANDELION,   //蒲公英上的版本
    VERSION_TARGET_TAOLE        //web提供的接口 （线上线下由传入的接口定）
}VERSION_TARGET;

@interface TLVerRequestEntity : NSObject

@property (nonatomic) VERSION_TARGET target;    //应用平台 fir 蒲公英  或web接口
@property (nonatomic,copy) NSString *api;       //fir时 传api; 蒲公英时 传“验证App短链接”api;  web接口时 传静态ip
@property (nonatomic,copy) NSString *appID;     //应用id（见fir或蒲公英后台设置）     web接口时 不传
@property (nonatomic,copy) NSString *apiKey;    //应用token（见fir或蒲公英后台设置）  web接口时 不传


@end
