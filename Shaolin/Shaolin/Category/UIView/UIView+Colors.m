//
//  UIView+Colors.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UIView+Colors.h"


@implementation UIView (Colors)
void drawGradationColor(CGContextRef context, CGPathRef path, NSArray <UIColor *> * colors, CGPoint startPoint, CGPoint endPoint){
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSMutableArray *cfColorArray = [@[] mutableCopy];
    for (int i = 0; i < colors.count; i++){
        [cfColorArray addObject:(__bridge id)colors[i].CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) cfColorArray, locations);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)setGradationColor:(NSArray <UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *layer = nil;
    for (CAGradientLayer *l in self.layer.sublayers){
        if ([l isKindOfClass:[CAGradientLayer class]]){
            layer = l;
            break;
        }
    }
    if (layer){
        [layer removeFromSuperlayer];
    }
    layer = [CAGradientLayer layer];
    if (colors.count == 0){
        [layer removeFromSuperlayer];
        return;
    }
    NSMutableArray *cgColors = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIColor *color in colors){
        [cgColors addObject:(id)color.CGColor];
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.colors = cgColors;
    
    layer.locations = nil;// @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)drawGradationColor:(CGContextRef)context pointArray:(NSArray <NSValue *> *)pointArray colors:(NSArray <UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    if (pointArray.count < 3) return;
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < pointArray.count; i++){
        CGPoint point = [pointArray[i] CGPointValue];
        if (i == 0){
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        } else {
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }
    }
    CGPathCloseSubpath(path);

    //绘制渐变色
    drawGradationColor(context, path, colors, startPoint, endPoint);
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
}

- (void)setShadowAndColor:(UIColor *)color {
    // 阴影颜色
    self.layer.shadowColor = color.CGColor;
    // 阴影偏移，默认(0, -3)
//    self.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 5;
}
@end
