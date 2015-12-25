//
//  TLObjectEncoderDecoder.h
//  Quokka
//
//  Created by davidli on 15/12/10.
//  Copyright © 2015年 X. All rights reserved.
//

#ifndef TLObjectEncoderDecoder_h
#define TLObjectEncoderDecoder_h

#import <objc/runtime.h>

//序列化工具使用示例:

/* 
 *1、TLObject头文件中声明NSCoding协议
#import <Foundation/Foundation.h>

@interface TLObject : NSObject<NSCoding>

@property (nonatomic, copy) NSString *mName;
@property (nonatomic) BOOL mIsTrue;
@property (nonatomic) NSInteger mInteger;
@property (nonatomic) UIImage *mImage;

@end

 *2、m文件中导入头文件和宏即可

#import "TLObject.h"
#import "TLObjectEncoderDecoder.h"

@implementation TLObject

TLObjectCoderDecoder()

@end
 */


#define TLObjectCoderDecoder() \
\
- (id)initWithCoder:(NSCoder *)coder \
{ \
    Class cls = [self class]; \
    while (cls != [NSObject class]) { \
        /*判断是自身类还是父类 自身时取IvaList 父类时取properList*/ \
        BOOL isSelfClass = (cls == [self class]); \
        unsigned int iVarCount = NONE;    /*私有变量+属性的数量*/ \
        unsigned int propVarCount = NONE; /*属性的数量*/ \
        unsigned int sharedVarCount = NONE; \
\
        Ivar *ivarList = isSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/ \
        objc_property_t *propList = isSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/ \
        sharedVarCount = isSelfClass ? iVarCount : propVarCount; \
\
        for (int i = NONE; i < sharedVarCount; i++) { \
            /*私有变量或属性名*/ \
            const char *varName = isSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName]; \
            NSString *firstStr = [key substringToIndex:ONE]; \
            /*如果是自身类 取的是IvaList 属性名前会带下划线“_” 为了统一 序列化时去掉下划线*/ \
            if (isSelfClass && [firstStr isEqualToString:@"_"]) { \
                key = [key substringFromIndex:ONE]; \
            } \
            /*私有变量或属性值*/ \
            id varValue = [coder decodeObjectForKey:key]; \
            if (varValue) { \
                [self setValue:varValue forKey:key]; \
            } \
        } \
        /*释放*/ \
        free(ivarList); \
        free(propList); \
        /*指针指向父类 对父类属性进行序列化*/ \
        cls = class_getSuperclass(cls); \
    } \
    return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)coder \
{ \
    Class cls = [self class]; \
    while (cls != [NSObject class]) { \
        /*判断是自身类还是父类 同上*/ \
        BOOL isSelfClass = (cls == [self class]); \
        unsigned int iVarCount = NONE;    /*私有变量+属性的总数*/ \
        unsigned int propVarCount = NONE; /*属性的总数*/ \
        unsigned int sharedVarCount = NONE; \
\
        Ivar *ivarList = isSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/ \
        objc_property_t *propList = isSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/ \
        sharedVarCount = isSelfClass ? iVarCount : propVarCount; \
\
        for (int i = NONE; i < sharedVarCount; i++) { \
            /*私有变量或属性名*/ \
            const char *varName = isSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName]; \
            NSString *firstStr = [key substringToIndex:ONE]; \
            /*如果是自身类 取的是IvaList 属性名前会带下划线“_” 为了统一 序列化时去掉下划线*/ \
            if (isSelfClass && [firstStr isEqualToString:@"_"]) { \
                key = [key substringFromIndex:ONE]; \
            } \
            /*注：valueForKey只获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(获取父类私有变量会崩溃)*/ \
            id varValue = [self valueForKey:key]; \
            if (varValue) { \
                [coder encodeObject:varValue forKey:key]; \
            } \
        } \
        /*释放*/ \
        free(ivarList); \
        free(propList); \
        /*指针指向父类 对父类属性进行序列化*/ \
        cls = class_getSuperclass(cls); \
    } \
} \




//copy协议使用示例：
/*
 与序列化协议使用规则相同 m文件中直接调用即可
 */

#define TLObjectCopy() \
\
- (id)copyWithZone:(NSZone *)zone \
{\
    id copy = [[[self class] allocWithZone:zone] init];\
    Class cls = [self class];\
    while (cls != [NSObject class]) {\
        /*判断是自身类还是父类*/ \
        BOOL IsSelfClass = (cls == [self class]); \
        unsigned int iVarCount = NONE; \
        unsigned int propVarCount = NONE;\
        unsigned int sharedVarCount = NONE;\
\
        Ivar *ivarList = IsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/\
        objc_property_t *propList = IsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/\
        sharedVarCount = IsSelfClass ? iVarCount : propVarCount;\
\
        for (int i = NONE; i < sharedVarCount; i++) {\
            const char *varName = IsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));\
            NSString *key = [NSString stringWithUTF8String:varName];\
            NSString *firstStr = [key substringToIndex:ONE]; \
            if (IsSelfClass && [firstStr isEqualToString:@"_"]) { \
                key = [key substringFromIndex:ONE]; \
            }\
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/\
            id varValue = [self valueForKey:key];\
            if (varValue) {\
                [copy setValue:varValue forKey:key];\
            }\
        }\
        free(ivarList);\
        free(propList);\
        cls = class_getSuperclass(cls);\
    }\
    return copy;\
}\


#endif /* TLObjectEncoderDecoder_h */
