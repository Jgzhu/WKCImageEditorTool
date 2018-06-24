//
//  WKCDrawTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCDrawTool.h"
#import "WKCCaptureTool.h"
@interface WKCDraeContent: NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;

@end

@implementation WKCDraeContent

- (instancetype)init {
    if (self = [super init]) {
        _path = [UIBezierPath bezierPath];
        _path.lineCapStyle = kCGLineCapRound;
        _path.lineJoinStyle = kCGLineJoinRound;
        _path.lineWidth = 8;
        _path.flatness = 1;
        _color = [UIColor redColor];
    }
    return self;
}

@end

@interface WKCDrawTool(){
    
    WKCDraeContent *_content;
    
    UIImage *_tmpImage;
}

@end

@implementation WKCDrawTool

#pragma mark ---<OutsideMethod>---

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor redColor];
        self.lineWidth = 8;
        self.hidden = YES;
    }
    return self;
}

- (void)fireOn {
    self.hidden = NO;
}

- (void)fireOff {
    self.hidden = YES;
}

- (void)callBack {
    
    UIImage *image = [WKCCaptureTool captureView:self.superview.superview isSave:NO completionHandle:^(BOOL isSuccess, NSError *error) {
      
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawTool:didFinishEditImage:)]) {
        [self.delegate drawTool:self didFinishEditImage:image];
    }
}

- (void)cleanUp {
    _tmpImage = nil;
    [self setNeedsDisplay];
}

- (void)eraser{
    self.lineColor = [UIColor clearColor];
}

#pragma mark ---<PrivateMethod>---

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_tmpImage) {
        [_tmpImage drawAtPoint:CGPointZero];
    }
    
    [_content.color setStroke];
    if (_content.color == [UIColor clearColor]) {
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    else {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
    
    [_content.path stroke];
    [super drawRect:rect];
}

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self touchPoint:touches];
    _content = [WKCDraeContent new];
    _content.color = self.lineColor;
    _content.path.lineWidth = self.lineWidth;
    [_content.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint previousPoint2 = _content.path.currentPoint;
    CGPoint previousPoint1 = [self touchPrePoint:touches];
    CGPoint currentPoint = [self touchPoint:touches];
    CGPoint mid1 = midPoint(previousPoint1, currentPoint);
    [_content.path addQuadCurveToPoint:mid1 controlPoint:previousPoint1];
    
    CGFloat minX = MIN(MIN(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat minY = MIN(MIN(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat maxX = MAX(MAX(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat maxY = MAX(MAX(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat space = self.lineWidth * 0.5 + 1;
    CGRect drawRect = CGRectMake(minX-space, minY-space, maxX-minX+self.lineWidth, maxY-minY+self.lineWidth);
    
    [self setNeedsDisplayInRect:drawRect];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint previousPoint2 = _content.path.currentPoint;
    CGPoint previousPoint1 = [self touchPrePoint:touches];
    CGPoint currentPoint = [self touchPoint:touches];
    [_content.path addQuadCurveToPoint:currentPoint controlPoint:previousPoint1];
    
    CGFloat minX = MIN(MIN(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat minY = MIN(MIN(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat maxX = MAX(MAX(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat maxY = MAX(MAX(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat space = self.lineWidth * 0.5 + 1;
    CGRect drawRect = CGRectMake(minX-space, minY-space, maxX-minX+self.lineWidth+2, maxY-minY+self.lineWidth+2);
    
    [self setNeedsDisplayInRect:drawRect];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    _tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (CGPoint)touchPrePoint:(NSSet<UITouch *> *)touches {
    UITouch *validTouch = nil;
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self]) {
            validTouch = touch;
            break;
        }
    }
    
    if (validTouch) {
        return [validTouch previousLocationInView:self];
    }
    else {
        return CGPointMake(-1, -1);
    }
}

- (CGPoint)touchPoint:(NSSet<UITouch *> *)touches {
    UITouch *validTouch = nil;
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self]) {
            validTouch = touch;
            break;
        }
    }
    if (validTouch) {
        return [validTouch locationInView:self];
    }
    else {
        return CGPointMake(-1, -1);
    }
}

@end
