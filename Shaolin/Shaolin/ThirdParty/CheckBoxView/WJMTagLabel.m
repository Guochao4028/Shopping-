//
//  WJMTagLabel.m
//  Lottery
//
//  Created by wangjingming on 2020/3/10.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTagLabel.h"

static const CGFloat kPadding10 = 10;

@interface WJMTagLabel()
@property (nonatomic, strong) UIBezierPath *tagPath;
@property (nonatomic, strong) NSMutableArray *layerArray;
@end

@implementation WJMTagLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = WJMTagLabelStyle_BubblesStyle;
        self.triangleSide = 4;
        self.layerArray = [@[] mutableCopy];
    }
    return self;
}
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (self.style == WJMTagLabelStyle_RadioStyle || self.style == WJMTagLabelStyle_RightTopTickStyle || self.style == WJMTagLabelStyle_RightBottomTickStyle){
        [self reloadTagLayer];
    }
    if (self.normalTextColor && self.selectTextColor){
        if (selected){
            self.textColor = self.selectTextColor;
        } else {
            self.textColor = self.normalTextColor;
        }
    }
}

- (void)setNormalImage:(UIImage *)normalImage{
    _normalImage = normalImage;
}

- (void)setSelectImage:(UIImage *)selectImage{
    _selectImage = selectImage;
}

#pragma mark -
- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadTagLayer];
}

- (void)reloadTagLayer{
    [self.layerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layerArray removeAllObjects];
    CGRect frame = self.bounds;
    if (self.style == WJMTagLabelStyle_RadioStyle){
        [self reloadRadioStyleBezierPath:frame];
    } else if (self.style == WJMTagLabelStyle_RightTopTickStyle || self.style == WJMTagLabelStyle_RightBottomTickStyle){
        [self reloadTickStyleBezierPath:frame];
    } else {
        [self reloadBubblesStyleBezierPath:frame];
    }
}

- (void)reloadBubblesStyleBezierPath:(CGRect)frame{
    /*
        1.5PI
    01PI     0PI
        0.5PI
     */
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame) - self.triangleSide;
    CGFloat cornerRadius = h/5;
    
    UIBezierPath *tagPath = [UIBezierPath new];
    [tagPath moveToPoint:CGPointMake(cornerRadius, 0)];
    [tagPath addLineToPoint:CGPointMake(w - cornerRadius, 0)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, cornerRadius) radius:cornerRadius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(w, h - cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0 endAngle:0.5*M_PI clockwise:YES];
    
    [tagPath addLineToPoint:CGPointMake(w/2 + self.triangleSide, h)];
    [tagPath addLineToPoint:CGPointMake(w/2, h+self.triangleSide)];
    [tagPath addLineToPoint:CGPointMake(w/2 - self.triangleSide, h)];
    
    [tagPath addLineToPoint:CGPointMake(cornerRadius, h)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0.5*M_PI endAngle:M_PI clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(0, cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
    
    [tagPath stroke];
    [tagPath fill];
    [tagPath closePath];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = frame;
    layer.path = tagPath.CGPath;
    layer.fillColor = [UIColor redColor].CGColor;// [UIColor redColor].CGColor;
    self.layer.mask = layer;
}

- (void)reloadRadioStyleBezierPath:(CGRect)frame{
    CGRect rect = [self textRectForBounds:frame limitedToNumberOfLines:self.numberOfLines];
    if (self.textAlignment == NSTextAlignmentCenter){
        rect.origin.x -= self.triangleSide;// + kPadding10;
        rect.size.width -= self.triangleSide;// + kPadding10);
    } else if (self.textAlignment == NSTextAlignmentRight){
        rect.origin.x -= self.triangleSide;// + kPadding10;
        rect.size.width -= self.triangleSide;// + kPadding10;
    }
    if (rect.origin.x < 1){
        rect.origin.x = 1;
    }
    CGFloat x = CGRectGetMinX(rect);
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame);
    
    CGFloat outerRingRadius = self.triangleSide;
    if (self.normalImage && self.selectImage){
        CALayer *layer = [CALayer layer];
        if (self.selected){
            layer.contents = (__bridge id)self.selectImage.CGImage;
        } else {
            layer.contents = (__bridge id)self.normalImage.CGImage;
        }
        outerRingRadius = outerRingRadius;// * self.layer.contentsScale;
        layer.contentsScale = self.layer.contentsScale;
        layer.frame = CGRectMake(x, (h - outerRingRadius)/2, outerRingRadius, outerRingRadius);
        [self.layer addSublayer:layer];
        [self.layerArray addObject:layer];
    } else {
        CGFloat innerRingRadius = outerRingRadius/2;
        UIBezierPath *outerRingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x + outerRingRadius, h/2) radius:outerRingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer *outerLayer = [CAShapeLayer layer];
        outerLayer.frame = self.bounds;
        outerLayer.path = outerRingPath.CGPath;
        outerLayer.strokeColor = [UIColor colorWithRed:237/255.0 green:169/255.0 blue:158/255.0 alpha:1].CGColor;
        outerLayer.fillColor = [UIColor colorWithRed:251/255.0 green:244/255.0 blue:241/255.0 alpha:1].CGColor;
        
        [self.layer addSublayer:outerLayer];
        [self.layerArray addObject:outerLayer];
        
        if (self.selected){
            UIBezierPath *innerRingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x + outerRingRadius/2 + innerRingRadius, h/2) radius:innerRingRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
            
            CAShapeLayer *innerRingLayer = [CAShapeLayer layer];
            innerRingLayer.frame = self.bounds;
            innerRingLayer.path = innerRingPath.CGPath;
            innerRingLayer.fillColor = [UIColor colorWithRed:213/255.0 green:88/255.0 blue:69/255.0 alpha:1].CGColor;
            
            [self.layer addSublayer:innerRingLayer];
            [self.layerArray addObject:innerRingLayer];
        }
    }
}

- (void)reloadTickStyleBezierPath:(CGRect)frame{
    if (self.selected){
        CGFloat w = CGRectGetWidth(frame);
        CGFloat h = CGRectGetHeight(frame);
        if (self.selectImage){
            CALayer *layer = [CALayer layer];
            layer.contents = (__bridge id)self.selectImage.CGImage;;
            CGFloat triangleSide = self.triangleSide;// * self.layer.contentsScale;
            layer.contentsScale = self.layer.contentsScale;
            if (self.style == WJMTagLabelStyle_RightTopTickStyle){
                layer.frame = CGRectMake(w - triangleSide, 0, triangleSide, triangleSide);
            } else {
                layer.frame = CGRectMake(w - triangleSide, h - triangleSide, triangleSide, triangleSide);
            }
            [self.layer addSublayer:layer];
            [self.layerArray addObject:layer];
            return;
        }
        /*
         
             1.5PI
           PI     PI
             0.5PI
         
             1  2
                3
         */
        UIBezierPath *semicirclePath = [UIBezierPath bezierPath];
        CGFloat tickY = 0;
        if (self.style == WJMTagLabelStyle_RightTopTickStyle){
            [semicirclePath addArcWithCenter:CGPointMake(w, 0) radius:self.triangleSide startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
//            kImportantReminder(@"这里出现了傻逼问题semicirclePath只画出了一个残废的扇形(弧线M_PI_2到M_PI,只过了1、3点,没经过2点)")
//            kImportantReminder(@"所以补了一个appendPath(一个经过1、2、3点的三角形)作补充,具体问题以后有时间再调整吧")
            UIBezierPath *appendPath = [UIBezierPath bezierPath];
            [appendPath moveToPoint:CGPointMake(w - self.triangleSide, 0)];
            [appendPath addLineToPoint:CGPointMake(w, 0)];
            [appendPath addLineToPoint:CGPointMake(w, self.triangleSide)];

            [semicirclePath appendPath:appendPath];
        } else {
            tickY = h - self.triangleSide;
            [semicirclePath addArcWithCenter:CGPointMake(w, h) radius:self.triangleSide startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
            
            UIBezierPath *appendPath = [UIBezierPath bezierPath];
            [appendPath moveToPoint:CGPointMake(w, h - self.triangleSide)];
            [appendPath addLineToPoint:CGPointMake(w, h)];
            [appendPath addLineToPoint:CGPointMake(w - self.triangleSide, h)];

            [semicirclePath appendPath:appendPath];
        }
        
        UIBezierPath *tickPath = [UIBezierPath new];
        [tickPath moveToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/3, tickY + self.triangleSide/2)];
        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/5*2 + 2, tickY + self.triangleSide/5*3)];
        [tickPath addLineToPoint:CGPointMake(w - self.triangleSide + self.triangleSide/4*3, tickY + self.triangleSide/3)];
        [tickPath stroke];
         
        CAShapeLayer *semicircleLayer = [CAShapeLayer layer];
        semicircleLayer.frame = self.bounds;
        semicircleLayer.fillColor = [UIColor colorWithRed:215/255.0 green:88/255.0 blue:63/255.0 alpha:1].CGColor;
        semicircleLayer.path = semicirclePath.CGPath;
        
        CAShapeLayer *tickLayer = [CAShapeLayer layer];
        tickLayer.frame = self.bounds;
        tickLayer.fillColor = [UIColor clearColor].CGColor;
        tickLayer.strokeColor = [UIColor whiteColor].CGColor;
        tickLayer.path = tickPath.CGPath;
        
        [self.layer addSublayer:semicircleLayer];
        [self.layer addSublayer:tickLayer];
        
        [self.layerArray addObject:semicircleLayer];
        [self.layerArray addObject:tickLayer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect{
    if (self.style == WJMTagLabelStyle_RadioStyle){
        rect.origin.x = self.triangleSide + kPadding10;
        rect.size.width -= (self.triangleSide + kPadding10);
    } else if (self.style == WJMTagLabelStyle_RightTopTickStyle || self.style == WJMTagLabelStyle_RightBottomTickStyle){
        
    } else {
        rect.size.height = rect.size.height - self.triangleSide;
    }
    [super drawTextInRect:rect];
}
@end
