//
//  XDateUtil.h
//  XMix
//
//  Created by davidli on 15/7/27.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDateUtil : NSObject


/**
 *  时间戳换算成HH:MM:SS格式的时间
 *
 *  @param timestamp 时间戳
 *
 *  @return 格式化后的时间string
 */
+ (NSString*) minutesFromTimestamp:(NSTimeInterval)timestamp;


@end
