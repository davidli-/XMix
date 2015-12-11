//
//  XMixConst.h
//  XMix
//
//  Created by davidli on 15/7/24.
//  Copyright (c) 2015年 X. All rights reserved.
//

#ifndef XMix_XMixConst_h
#define XMix_XMixConst_h

#define NONE            0
#define ONE             1
#define NEGATIVE       -1

#define MILLI 1000

#define FONT_NORMAL_NAME    @"Helvetica"//@"汉仪细圆简"
#define FONT_BOLD_NAME      @"Helvetica-Bold"//@"汉仪细圆简"

#define FONT_NORMAL(text_size)  [UIFont fontWithName:FONT_NORMAL_NAME size:text_size]
#define FONT_BOLD(text_size)    [UIFont fontWithName:FONT_BOLD_NAME size:text_size]


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define LOAD_TEXT(text) NSLocalizedString(text, nil)

#define TraceS(NSString_format, ...) NSLog(@"%@", [NSString stringWithFormat:(NSString_format), ##__VA_ARGS__])

#endif
