//
//  MapTipView.m
//  XMix
//
//  Created by davidli on 15/7/5.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "MapTipView.h"

#define ORC_RADIUS 5

@interface MapTipView ()

@end

@implementation MapTipView

-(id) init:(CGPoint) p str:(NSString*) str
{
    if(self = [super init]){
        path = [[UIBezierPath alloc] init];
        label = [[UILabel alloc] init];
        
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        font = [UIFont systemFontOfSize:15.0];
        label.font = font;
        
        [self setBackgroundColor: [UIColor clearColor]];
        [self setAlpha:0.8];
        [self addSubview: label];
        [self set_point: p];
        [self set_title: str];
    }
    
    return (self);
}


-(void)set_point:(CGPoint)p
{
    point = p;
}


- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setFill];
    [path fill];
}


-(void) set_title:(NSString*) str
{
    label.text = str;
    CGSize csize;
    csize.width = 250;
    csize.height = 60;
    
    CGRect rect = [label.text boundingRectWithSize:csize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font,NSLigatureAttributeName:@(0)} context:nil];
    
    size = rect.size;
    
    label.frame = CGRectMake(10, 3, size.width, size.height);
    size.height += 15;
    size.width += 20;
    double bw = (size.width - ORC_RADIUS*3)/2;
    double x = point.x - bw;
    double y = point.y - size.height;
    origin.x = x;
    origin.y = y;
    self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    
    [self set_path];
}


- (BOOL)pointInside:(CGPoint)p withEvent:(UIEvent *)event
{
    return [path containsPoint:p];
}


-(void)set_path
{
    double h = size.height - ORC_RADIUS*3;
    double bw = (size.width - ORC_RADIUS*3)/2;
    CGPoint p = CGPointMake(ORC_RADIUS, 0);
    [path moveToPoint:p];
    p.x += size.width - ORC_RADIUS*2;
    [path addLineToPoint: p];
    p.y += ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1414926*1.5
                  endAngle:0
                 clockwise:YES];
    p.x += ORC_RADIUS;
    p.y += h;
    [path addLineToPoint: p];
    
    p.x -= ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:0
                  endAngle:3.1415926/2.0
                 clockwise:YES];
    p.y += ORC_RADIUS;
    p.x -= bw;
    [path addLineToPoint: p];
    
    p.x -= ORC_RADIUS/2;
    p.y += ORC_RADIUS;
    [path addLineToPoint: p];
    p.x -= ORC_RADIUS/2;
    p.y -= ORC_RADIUS;
    [path addLineToPoint: p];
    p.x -= bw;
    [path addLineToPoint: p];
    p.y -= ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1415926/2.0
                  endAngle:3.1415926
                 clockwise:YES];
    p.x -= ORC_RADIUS;
    p.y -= h;
    [path addLineToPoint: p];
    p.x += ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1415926
                  endAngle:3.1415926*1.5
                 clockwise:YES];
    [path closePath];
}


@end
