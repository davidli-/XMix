//
//  DrawView.m
//  XMix
//
//  Created by davidli on 15/11/24.
//  Copyright © 2015年 X. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

-(void)drawRect:(CGRect)rect
{
    //NO.1画线条
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 10, 20);
    CGContextAddLineToPoint(context, 30, 50);
    CGContextSetRGBStrokeColor(context, ONE, ONE, ONE, ONE);
    CGContextStrokePath(context);


    //NO.2画文字
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor (context, ONE, ONE, ONE, ONE);
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    NSString *string = @"UIView drawRect示例";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = font;
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [string drawInRect:CGRectMake(120, 170, 200, 20) withAttributes:(dic)];

    //NO.3画方形
    CGContextSetRGBFillColor(context, ONE, ONE, ONE, ONE);
    CGContextFillRect(context, CGRectMake(80, 20, 100, 20));
    CGContextStrokePath(context);

    //NO.4画正方形边框
    CGContextSetLineWidth(context, 2.0);
    CGContextAddRect(context, CGRectMake(200, 20, 100, 20));
    CGContextStrokePath(context);

    //NO.5椭圆
    CGRect aRect= CGRectMake(320, 20, 20, 20);
    CGContextSetLineWidth(context, 2);
    CGContextFillEllipseInRect(context, aRect); //椭圆
    CGContextDrawPath(context, kCGPathStroke);


    //NO.6画圆线
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 50, 100);//画切线（示意用）
    CGContextAddLineToPoint(context, 50, 150);//画切线（示意用）
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddArcToPoint(context, 50, 100, 50, 150, 50);
    CGContextStrokePath(context);

    //NO.7Bezier曲线
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 250, 100);
    CGContextAddCurveToPoint(context, 0, 150, 200, 200, 300, 50);
    CGContextStrokePath(context);

    self.backgroundColor = RGBACOLOR(0, 255, 255, 0.9);
}

@end
