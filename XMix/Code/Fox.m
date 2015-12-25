//
//  Fox.m
//  XMix
//
//  Created by davidli on 15/12/25.
//  Copyright © 2015年 X. All rights reserved.
//

#import "Fox.h"
#import "Student.h"
#import <objc/runtime.h>

@implementation Fox

- (void)testMethod
{
    SEL myMethod = @selector(testMethod);
    NSMethodSignature * sig  = [[Student new] methodSignatureForSelector:myMethod];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:[Student new]];
    [invocatin setSelector:myMethod];
//    int a=1;
//    int b=2;
//    int c=3;
//    [invocatin setArgument:&a atIndex:2];
//    [invocatin setArgument:&b atIndex:3];
//    [invocatin setArgument:&c atIndex:4];
//    [invocatin retainArguments];
    [invocatin invoke];
}

- (void)onInvocation:(int)a param2:(int)b param3:(int)c
{
    TraceS(@"HAHAHAH");
}

void functionForMethod1(id self,SEL _cmd,NSString * saySomething)
{
    TraceS(@"What does the fox say?");
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
    //动态添加 return YES之后 直接调用此方法 return NO时 接着寻找Sel
//    NSString *select = NSStringFromSelector(sel);
//    if ([select rangeOfString:@"testMethod"].length != NSNotFound) {
//        class_addMethod(self.class, sel, (IMP)functionForMethod1, "v@:@");//不带参数时 "@:"
//        return YES;
//    }
    return NO;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil) {
        signature = [[Student new] methodSignatureForSelector:aSelector];
    }
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    TraceS(@"forwardInvocation:%@" , anInvocation);
    SEL seletor = [anInvocation selector];
    if ([[Student new] respondsToSelector:seletor]) {
        [anInvocation invokeWithTarget:[Student new]];
    }
}

@end
