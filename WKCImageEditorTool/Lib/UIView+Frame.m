//
//  UIView+Frame.m
//  bcbcbcb
//
//  Created by 魏昆超 on 2018/6/19.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "UIView+Frame.h"
BOOL pan = NO;
@implementation UIView (Frame)
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

+ (NSString *)cellIdentify {
    return NSStringFromClass(self);
}

- (void)shadowWithCornerRadius:(CGFloat)radius
                         color:(UIColor *)color
                        offset:(CGSize)offset
                       opacity:(CGFloat)opacity
                          blur:(CGFloat)blur {
    self.backgroundColor = [UIColor whiteColor]; //不给背景色,加不出来.
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = radius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = blur / 2;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)setIsCanPan:(BOOL)isCanPan {
    if (isCanPan) {
        [self addPanAnimation];
    }
    pan = isCanPan;
}

- (BOOL)isCanPan {
    return pan;
}

- (void)addPanAnimation {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnPan:)];
    [self addGestureRecognizer:pan];
}

- (void)clickedOnPan:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view.superview];
    CGPoint newCenter = CGPointMake(sender.view.center.x+ point.x,
                                    sender.view.center.y + point.y);
    newCenter.y = MAX(sender.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(sender.view.superview.frame.size.height - sender.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(sender.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(sender.view.superview.frame.size.width - sender.view.frame.size.width/2,newCenter.x);
    sender.view.center = newCenter;
    [sender setTranslation:CGPointZero inView:sender.view.superview];
}
@end
