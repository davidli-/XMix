//
//  MapTipView.h
//  XMix
//
//  Created by davidli on 15/7/5.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MapTipView : UIView{
    
    CGPoint origin;
    CGPoint point;
    CGSize size;
    UIFont *font;
    UILabel *label;
    NSString *title;
    UIBezierPath *path;
}

@property (nonatomic, strong) NSString *title;

-(void)set_path;
-(id) init:(CGPoint) p str:(NSString*) str;
-(void)set_point:(CGPoint)p;
-(void)set_title:(NSString*) str;
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end
