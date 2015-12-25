//
//  Student.m
//  XMix
//
//  Created by davidli on 15/12/10.
//  Copyright © 2015年 X. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>
#import "TLObjectEncoderDecoder.h"

@implementation Student

TLObjectCoderDecoder()

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];
    Class cls = [self class];
    while (cls != [NSObject class]) {
        /*判断是自身类还是父类*/
        BOOL IsSelfClass = (cls == [self class]);
        unsigned int iVarCount = NONE;
        unsigned int propVarCount = NONE;
        unsigned int sharedVarCount = NONE;

        Ivar *ivarList = IsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
        objc_property_t *propList = IsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
        sharedVarCount = IsSelfClass ? iVarCount : propVarCount;

        for (int i = NONE; i < sharedVarCount; i++) {
            const char *varName = IsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            NSString *firstStr = [key substringToIndex:ONE]; \
            if (IsSelfClass && [firstStr isEqualToString:@"_"]) { \
                key = [key substringFromIndex:ONE]; \
            }
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
            id varValue = [self valueForKey:key];
            if (varValue) {
                [copy setValue:varValue forKey:key];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return copy;
}

-(void)testMethod
{
    TraceS(@"+++++This is a studend!");
}
@end
