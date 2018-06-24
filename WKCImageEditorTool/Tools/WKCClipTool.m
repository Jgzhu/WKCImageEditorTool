//
//  WKCClipTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/24.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCClipTool.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>
#import "WKCCaptureTool.h"

@interface WKCClipBall:UIView
/**球颜色*/
@property (nonatomic, strong) UIColor * ballColor;

@end


@implementation WKCClipBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.ballColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rct = self.bounds;
    rct.origin.x = rct.size.width / 2 - rct.size.width / 6;
    rct.origin.y = rct.size.height / 2 - rct.size.height / 6;
    rct.size.width /= 3;
    rct.size.height /= 3; //在这里改变球大小
    CGContextSetFillColorWithColor(context, self.ballColor.CGColor); //在这里改变求颜色
    CGContextFillEllipseInRect(context, rct);
}

@end

/**网格layer*/
@interface WKCClipGirdLayer:CALayer
@property (nonatomic, assign) CGRect clippingRect; //裁剪范围
@property (nonatomic, strong) UIColor *bgColor;    //背景颜色
@property (nonatomic, strong) UIColor *gridColor;  //线条颜色

@end

@implementation WKCClipGirdLayer
- (void)drawInContext:(CGContextRef)context
{
    CGRect rct = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rct);
    
    //清除范围（截图范围）
    CGContextClearRect(context, _clippingRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 0.8);
    
    rct = self.clippingRect;
    
    CGContextBeginPath(context);
    CGFloat dW = 0;
    //画竖线
    for(int i=0;i<4;++i){
        CGContextMoveToPoint(context, rct.origin.x+dW, rct.origin.y);
        CGContextAddLineToPoint(context, rct.origin.x+dW, rct.origin.y+rct.size.height);
        dW += _clippingRect.size.width/3;
    }
    
    dW = 0;
    
    //画横线
    for(int i=0;i<4;++i){
        CGContextMoveToPoint(context, rct.origin.x, rct.origin.y+dW);
        CGContextAddLineToPoint(context, rct.origin.x+rct.size.width, rct.origin.y+dW);
        dW += rct.size.height/3;
    }
    CGContextStrokePath(context);
}

@end

static const NSUInteger kLeftTopCircleView = 1;
static const NSUInteger kLeftBottomCircleView = 2;
static const NSUInteger kRightTopCircleView = 3;
static const NSUInteger kRightBottomCircleView = 4;

@interface WKCClipGridItem:UIView

@property (nonatomic, assign) CGRect clippingRect;  //裁剪范围

/**清除线球*/
- (void)cleanUp;
/**设置裁剪view的背景颜色*/
- (void)setBgColor:(UIColor*)bgColor;
/**设置裁剪的网格颜色*/
- (void)setGridColor:(UIColor*)gridColor;

@end

@implementation WKCClipGridItem{
    WKCClipGirdLayer *_gridLayer;
    //4个角
    WKCClipBall *_ltView;
    WKCClipBall *_lbView;
    WKCClipBall *_rtView;
    WKCClipBall *_rbView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gridLayer = [[WKCClipGirdLayer alloc] init];
        _gridLayer.frame = self.bounds;
        [self.layer addSublayer:_gridLayer];
        
        _ltView = [self clippingCircleWithTag:kLeftTopCircleView];
        _lbView = [self clippingCircleWithTag:kLeftBottomCircleView];
        _rtView = [self clippingCircleWithTag:kRightTopCircleView];
        _rbView = [self clippingCircleWithTag:kRightBottomCircleView];
        
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGridView:)];
        [self addGestureRecognizer:panGesture];
        
        self.clippingRect = self.bounds;
    }
    return self;
}

//4个角的拖动圆球
- (WKCClipBall*)clippingCircleWithTag:(NSInteger)tag {
    CGRect frame = CGRectZero;
    if (tag == kLeftTopCircleView) {
        frame = CGRectMake(0, 0, 60, 60);
    }else if (tag == kLeftBottomCircleView) {
        frame = CGRectMake(0, self.height - 60, 60, 60);
    }else if (tag == kRightTopCircleView) {
        frame = CGRectMake(self.width - 60, 0, 60, 60);
    }else if (tag == kRightBottomCircleView) {
        frame = CGRectMake(self.width - 60, self.height - 60, 60, 60);
    }
    WKCClipBall *view = [[WKCClipBall alloc] initWithFrame:frame];
    view.tag = tag;
    view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCircleView:)];
    [view addGestureRecognizer:panGesture];
    [self addSubview:view];
    return view;
}

- (void)cleanUp {
    [_ltView removeFromSuperview];
    [_lbView removeFromSuperview];
    [_rtView removeFromSuperview];
    [_rbView removeFromSuperview];
    [_gridLayer removeFromSuperlayer];
}

- (void)setBgColor:(UIColor *)bgColor {
    _gridLayer.bgColor = bgColor;
}

- (void)setGridColor:(UIColor *)gridColor {
    _gridLayer.gridColor = gridColor;
    _ltView.ballColor = gridColor;
    _lbView.ballColor = gridColor;
    _rtView.ballColor = gridColor;
    _rbView.ballColor = gridColor;
}

- (void)setClippingRect:(CGRect)clippingRect {
    _clippingRect = clippingRect;
    _ltView.center = CGPointMake(_clippingRect.origin.x, _clippingRect.origin.y);
    _lbView.center = CGPointMake(_clippingRect.origin.x, _clippingRect.origin.y+_clippingRect.size.height);
    _rtView.center = CGPointMake(_clippingRect.origin.x+_clippingRect.size.width, _clippingRect.origin.y);
    _rbView.center = CGPointMake(_clippingRect.origin.x+_clippingRect.size.width, _clippingRect.origin.y+_clippingRect.size.height);
    _gridLayer.clippingRect = clippingRect;
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [_gridLayer setNeedsDisplay];
}

//拖动4个角
- (void)panCircleView:(UIPanGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self];
    CGPoint dp = [sender translationInView:self];
    
    CGRect rct = self.clippingRect;
    
    const CGFloat W = self.frame.size.width;
    const CGFloat H = self.frame.size.height;
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = W;
    CGFloat maxY = H;
    
    CGFloat ratio = (sender.view.tag == kLeftBottomCircleView || sender.view.tag == kRightTopCircleView) ? -0 : 0;
    
    switch (sender.view.tag) {
        case kLeftTopCircleView: // upper left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = rct.origin.y - ratio * rct.origin.x;
                CGFloat x0 = -y0 / ratio;
                minX = MAX(x0, 0);
                minY = MAX(y0, 0);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y > 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.x = point.x;
            rct.origin.y = point.y;
            break;
        }
        case kLeftBottomCircleView: // lower left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio* rct.origin.x ;
                CGFloat xh = (H - y0) / ratio;
                minX = MAX(xh, 0);
                maxY = MIN(y0, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = point.y - rct.origin.y;
            rct.origin.x = point.x;
            break;
        }
        case kRightTopCircleView: // upper right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = rct.origin.y - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat x0 = -y0 / ratio;
                maxX = MIN(x0, W);
                minY = MAX(yw, 0);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y > 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.y = point.y;
            break;
        }
        case kRightBottomCircleView: // lower right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat xh = (H - y0) / ratio;
                maxX = MIN(xh, W);
                maxY = MIN(yw, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = point.y - rct.origin.y;
            break;
        }
        default:
            break;
    }
    self.clippingRect = rct;
}

//移动裁剪view
- (void)panGridView:(UIPanGestureRecognizer*)sender {
    static BOOL dragging = NO;
    static CGRect initialRect;
    
    if(sender.state==UIGestureRecognizerStateBegan){
        CGPoint point = [sender locationInView:self];
        dragging = CGRectContainsPoint(_clippingRect, point);
        initialRect = self.clippingRect;
    }
    else if(dragging){
        CGPoint point = [sender translationInView:self];
        CGFloat left  = MIN(MAX(initialRect.origin.x + point.x, 0), self.frame.size.width-initialRect.size.width);
        CGFloat top   = MIN(MAX(initialRect.origin.y + point.y, 0), self.frame.size.height-initialRect.size.height);
        
        CGRect rct = self.clippingRect;
        rct.origin.x = left;
        rct.origin.y = top;
        self.clippingRect = rct;
    }
}

@end

@interface WKCClipTool()
@property (nonatomic, strong) WKCClipGridItem * gridView;
@property (nonatomic, strong) UIImage * image;
@end

@implementation WKCClipTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.gridView];
        self.hidden = YES;
    }
    return self;
}

- (void)fireOn {
    self.gridView.clippingRect = self.bounds;
    self.hidden = NO;
}

- (void)fireOff {
    self.hidden = YES;
}

- (void)callBackEdited {
    
    UIImage *image = [WKCCaptureTool captureRect:self.gridView.clippingRect fullImage:self.image isSave:NO completionHandle:^(BOOL isSuccess, NSError *error) {
       [self fireOff];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clipTool:didFinishEditImage:)]) {
        [self.delegate clipTool:self didFinishEditImage:image];
    }
}

- (void)refreshOrigin:(UIImage *)origin {
    self.image = origin;
}

- (void)refreshScale:(CGFloat)scale
           animation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.25f animations:^{
            [self refreshScale:scale];
        }];
    }else {
        [self refreshScale:scale];
    }
}

- (void)cleanUp {
    [self.gridView cleanUp];
}

- (void)setGridColor:(UIColor *)gridColor {
    _gridColor = gridColor;
    [self.gridView setGridColor:gridColor];
}

- (void)setGridBgColor:(UIColor *)gridBgColor {
    _gridBgColor = gridBgColor;
    [self.gridView setBgColor:gridBgColor];
}

- (void)refreshScale:(CGFloat)scale {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    if (scale < 1) {
        x = (1 - scale) / 2 * self.width;
        y = (1 - scale) / 2 * self.height;
        width = self.width - x * 2;
        height = self.height - y * 2;
    }else if(scale > 1){
        x = (scale - 1) / 3 * self.width;
        y = 0;
        width = self.width - x * 2;
        height = self.height;
    }else {
        x = 0;
        y = 0;
        width = self.width;
        height = self.height;
    }
    self.gridView.clippingRect = CGRectMake(x, y, width, height);
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (WKCClipGridItem *)gridView {
    if (!_gridView) {
        _gridView = [[WKCClipGridItem alloc] initWithFrame:self.bounds];
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.8]; //在这里改变背景色
        _gridView.gridColor = [[UIColor whiteColor] colorWithAlphaComponent:1]; //在这里改变网格颜色
        _gridView.clipsToBounds = NO;
    }
    return _gridView;
}

@end
