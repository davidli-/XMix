//
//  TLBackButton.m
//  Quokka
//
//  Created by Macmafia on 15/6/16.
//  Copyright (c) 2015年 Beijing Taole. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton


- (id)initWithBackType:(BACK_BTN_TYPE)mType images:(NSArray*)mImageArr text:(NSString*)mText target:(id)target selector:(SEL)selector{
    
    if (self = [super init]) {
        self = (BackButton*)[UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *imageNormal, *imageHighLight;
        if (mImageArr) {
            imageNormal    = [UIImage imageNamed:[mImageArr objectAtIndex:NONE]];
            imageHighLight = [UIImage imageNamed:[mImageArr objectAtIndex:ONE]];
        }else{
            
            imageNormal    = [UIImage imageNamed:@"icon_back_nor"];
            imageHighLight = [UIImage imageNamed:@"icon_back_pre"];
        }
        
        if (BACK_BTN_TYPE_IMAGE == mType) {
            [self setImage:imageNormal forState:UIControlStateNormal];
            [self setImage:imageHighLight forState:UIControlStateHighlighted];
        }
        else if (BACK_BTN_TYPE_TEXT == mType) {
            [self.titleLabel setFont:FONT_NORMAL(18)];
            [self setTitle:mText forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:RGBACOLOR(152, 156, 159, ONE) forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:imageNormal forState:UIControlStateNormal];
            [self setImage:imageHighLight forState:UIControlStateHighlighted];
            [self setTitle:mText forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:RGBACOLOR(152, 156, 159, ONE) forState:UIControlStateHighlighted];
        }
        
        [self sizeToFit];
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
