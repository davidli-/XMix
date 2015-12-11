//
//  TLMutableURLRequest.m
//  VersionHelper
//
//  Created by davidli on 15/9/21.
//  Copyright (c) 2015年 Taole. All rights reserved.
//

#import "TLMutableURLRequest.h"

@implementation TLMutableURLRequest

-(NSString *)uniqueKey{
    if (!_uniqueKey) {
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970] * 1000;
        _uniqueKey = [NSString stringWithFormat:@"%@+%@",@(time).stringValue, @(self.hash).stringValue];
    }
    return _uniqueKey;
}

@end
