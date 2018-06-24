//
//  WKCMosaicTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCMosaicTool.h"
#import "UIView+Frame.h"
#import "WKCCaptureTool.h"
#import "WKCFilterManager.h"

@interface WKCMosaicTool()
@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

/**原图*/
@property (nonatomic, strong) UIImage *image;
@end
@implementation WKCMosaicTool

#pragma mark ---<OutsideMethod>---

-(instancetype)initWithFrame:(CGRect)frame
                       image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = image;
        [self buildUI];
        [self buildData];
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
- (void)refreshOrigin:(UIImage *)origin {
    self.image = origin;
}

- (void)callBack {
    
    UIImage *image = [WKCCaptureTool captureView:self isSave:NO completionHandle:^(BOOL isSuccess, NSError *error) {
        self.hidden = YES;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mosaicTool:didFinishEditImage:)]) {
        [self.delegate mosaicTool:self didFinishEditImage:image];
    }
}

- (void)cleanUp {
    [self reset];
}

- (void)fullMosaic {
    
    UIImage *image = [WKCFilterManager mosaicFilterWithOriginImage:self.image];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mosaicTool:didFinishEditImage:)]) {
        [self.delegate mosaicTool:self didFinishEditImage:image];
    }
}

#pragma mark ---<PrivateMethon>---

- (void)reset {
    self.path = CGPathCreateMutable();
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

-(void)buildUI {
    [self addSubview:self.surfaceImageView];
    [self.layer addSublayer:self.imageLayer];
    [self.layer addSublayer:self.shapeLayer];
    self.imageLayer.mask = self.shapeLayer;
}

-(void)buildData {
    self.path = CGPathCreateMutable();
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
    [self addGestureRecognizer:pan];
}


-(void)panMethod:(UIPanGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self];
            CGPathMoveToPoint(self.path, NULL, point.x, point.y);
            CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
            self.shapeLayer.path = path;
            CGPathRelease(path);
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self];
            CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
            CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
            self.shapeLayer.path = path;
            CGPathRelease(path);
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
            
        default:
            break;
    }
}

//获取马赛克图层
- (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = orginImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,        //每个颜色值8bit
                                                  width*4, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[4] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + 4*index, 4);
                }else{
                    memcpy(bitmapData + 4*index, pixel, 4);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + 4*index, bitmapData + 4*preIndex, 4);
            }
        }
    }
    
    NSInteger dataLength = width*height* 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    //创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              8,
                                              32,
                                              width*4 ,
                                              colorSpace,
                                              kCGBitmapByteOrderDefault,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       8,
                                                       width*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage ;
}

- (void)dealloc {
    if (self.path) {
        CGPathRelease(self.path);
    }
}

#pragma mark ---<Setter>---
-(void)setImage:(UIImage *)image {
    _image = image;
    self.surfaceImageView.image = image;
    UIImage *mosaicImage = [self transToMosaicImage:_image blockLevel:50];
    self.imageLayer.contents = (id)mosaicImage.CGImage;
}

-(void)setMosaicWidth:(CGFloat)mosaicWidth {
    self.shapeLayer.lineWidth = mosaicWidth;
}

#pragma mark ---<Lazy init>---

- (UIImageView *)surfaceImageView {
    if (!_surfaceImageView) {
        _surfaceImageView = [UIImageView new];
        _surfaceImageView.contentMode = UIViewContentModeScaleAspectFill;
        _surfaceImageView.clipsToBounds = YES;
        _surfaceImageView.userInteractionEnabled = YES;
        _surfaceImageView.frame = self.bounds;
    }
    return _surfaceImageView;
}

- (CALayer *)imageLayer {
    if (!_imageLayer) {
        _imageLayer = [CALayer layer];
        _imageLayer.frame = self.bounds;
    }
    return _imageLayer;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.lineWidth = 10.f;
        _shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        _shapeLayer.fillColor = nil;
        _shapeLayer.frame = self.bounds;
    }
    return _shapeLayer;
}

@end
