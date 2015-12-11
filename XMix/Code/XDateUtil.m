//
//  XDateUtil.m
//  XMix
//
//  Created by davidli on 15/7/27.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "XDateUtil.h"

@implementation XDateUtil


+ (NSString*) minutesFromTimestamp:(NSTimeInterval)timestamp
{
    timestamp /= MILLI; //minus milliseconds
    unsigned long long seconds = timestamp;
    
    NSInteger minutes = (seconds / 60);
    seconds %= 60;
    
    NSInteger hour = minutes / 60;
    
    NSString * hourStr   = hour < 10 ? [NSString stringWithFormat:@"0%ld", hour] : [NSString stringWithFormat:@"%ld", hour];
    NSString * minuteStr = minutes < 10 ? [NSString stringWithFormat:@"0%ld", minutes] : [NSString stringWithFormat:@"%ld", minutes];
    NSString * secondStr = seconds < 10 ? [NSString stringWithFormat:@"0%llu", seconds] : [NSString stringWithFormat:@"%llu", seconds];
    
    NSString *result = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
    
    return result;
}


@end
