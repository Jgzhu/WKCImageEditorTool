//
//  WKCStickersTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCStickersTool.h"
#import "UIView+Frame.h"
#import "WKCCaptureTool.h"

@interface WKCScaleButton:UIView

- (instancetype)initWithFrame:(CGRect)frame
                 outsideColor:(UIColor *)outside
                  insideColor:(UIColor *)inside
                 outsideWidth:(CGFloat)width;

@end

@implementation WKCScaleButton{
    UIColor *_outside;
    UIColor *_insdide;
    CGFloat _outsideWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
                 outsideColor:(UIColor *)outside
                  insideColor:(UIColor *)inside
                 outsideWidth:(CGFloat)width {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _outside = outside;
        _insdide = inside;
        _outsideWidth = width;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rct = self.bounds;
    CGFloat radius = 0.7;
    rct.origin.x = 0.5 * (rct.size.width - radius * rct.size.width);
    rct.origin.y = 0.5 * (rct.size.height - radius * rct.size.height);
    rct.size.width = radius * rct.size.width;
    rct.size.height = radius * rct.size.height;
    CGContextSetFillColorWithColor(context, _insdide.CGColor);
    CGContextFillEllipseInRect(context, rct);
    CGContextSetStrokeColorWithColor(context, _outside.CGColor);
    CGContextSetLineWidth(context, _outsideWidth);
    CGContextStrokeEllipseInRect(context, rct);
}

@end

@interface WKCStickersItem:UIView{
    UIImage *_image;
    UIImage *_deleteImage;
    
    CGFloat _scale;    //当前缩放比例
    CGFloat _arg;       //当前旋转比例
    CGPoint _initialPoint; //表情的中心点
    CGFloat _initialScale;  //修改前的缩放比例
    CGFloat _initialArg;    //修改前旋转比例
    
    CGFloat _deleteWidth; //删除键宽
    CGFloat _deleteHeight; //删除键高
}

@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) WKCScaleButton * scaleButton;

@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

/**初始化*/
- (instancetype)initWithFrame:(CGRect)frame
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)delete;

/**刷新贴图*/
- (void)refreshStickerImage:(UIImage *)newSticker;

/**活跃状态 - 设置为NO去除边框线,YES恢复*/
- (void)setAcvitity:(BOOL)isActivity;

@end

@implementation WKCStickersItem

- (instancetype)initWithFrame:(CGRect)frame
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)delete {
    
    _deleteWidth = delete.size.width;
    _deleteHeight = delete.size.height;
    
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + 15 + _deleteWidth / 2, frame.size.height + 15 + _deleteHeight / 2)]) {
        
        self.userInteractionEnabled = YES;
        _image = sticker;
        _deleteImage = delete;
        _scale = 1;
        _arg = 0;
        
        [self addSubview:self.imageView];
        [self addSubview:self.deleteButton];
        [self addSubview:self.scaleButton];
        
        self.isCanPan = YES;
    }
    return self;
}

- (void)refreshStickerImage:(UIImage *)newSticker {
    _image = newSticker;
    self.imageView.image = newSticker;
    [self setAcvitity:YES];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.imageView.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.imageView.layer.borderWidth = borderWidth;
}

#pragma mark ----<PrivateMethod>----

- (void)setAcvitity:(BOOL)isActivity {
    if (isActivity) {
        if (!self.borderColor) self.borderColor = [UIColor blackColor];
        if (!self.borderWidth) self.borderWidth = 2;
        self.imageView.layer.borderColor = self.borderColor.CGColor;
        self.imageView.layer.borderWidth = self.borderWidth;
        self.deleteButton.hidden = NO;
        self.scaleButton.hidden = NO;
    }else {
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.imageView.layer.borderWidth = 0;
        self.deleteButton.hidden = YES;
        self.scaleButton.hidden = YES;
    }
}

- (void)clickDeleteBtn:(UIButton *)sender {
    if (self.superview) [self removeFromSuperview];
}

- (void)scaleBtnDidPan:(UIPanGestureRecognizer*)sender {
    CGPoint p = [sender translationInView:self.superview];
    static CGFloat tmpR = 1; //临时缩放值
    static CGFloat tmpA = 0; //临时旋转值
    if(sender.state == UIGestureRecognizerStateBegan){
        //表情view中的缩放按钮相对与表情view父视图中的位置
        _initialPoint = [self.superview convertPoint:self.scaleButton.center fromView:self.scaleButton.superview];
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        //缩放按钮中点与表情view中点的直线距离
        tmpR = sqrt(p.x*p.x + p.y*p.y); //开根号
        //缩放按钮中点与表情view中点连线的斜率角度
        tmpA = atan2(p.y, p.x);//反正切函数
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y); //拖动后的距离
    CGFloat arg = atan2(p.y, p.x);    // 拖动后的旋转角度
    //旋转角度
    _arg   = _initialArg + arg - tmpA; //原始角度+拖动后的角度 - 拖动前的角度
    //放大缩小的值
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    self.transform = CGAffineTransformIdentity;
    self.imageView.transform = CGAffineTransformMakeScale(_scale, _scale); //缩放
    CGRect rct = self.frame;
    CGFloat width = 15 + _deleteWidth / 2;
    CGFloat height = 15 + _deleteHeight / 2;
    rct.origin.x += (rct.size.width - (self.imageView.width + width)) / 2;
    rct.origin.y += (rct.size.height - (self.imageView.height + height)) / 2;
    rct.size.width  = self.imageView.width + width;
    rct.size.height = self.imageView.height + height;
    self.frame = rct;
    self.imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    self.transform = CGAffineTransformMakeRotation(_arg); //旋转
    self.imageView.layer.borderWidth = 1/_scale;
    self.imageView.layer.cornerRadius = 3/_scale;
}

#pragma mark ----<Setter、Getter>----

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:_image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.borderWidth = 2;
        _imageView.layer.cornerRadius = 4;
        _imageView.center = self.center;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, _deleteWidth, _deleteHeight);
        _deleteButton.center = self.imageView.frame.origin;
        [_deleteButton setBackgroundImage:_deleteImage forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:_deleteImage forState:UIControlStateHighlighted];
        [_deleteButton setBackgroundImage:_deleteImage forState:UIControlStateSelected];
        [_deleteButton addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (WKCScaleButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [[WKCScaleButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) outsideColor:[UIColor blackColor] insideColor:[UIColor whiteColor] outsideWidth:5];
        _scaleButton.center = CGPointMake(self.imageView.width + self.imageView.left, self.imageView.height + self.imageView.top);
        _scaleButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _scaleButton.userInteractionEnabled = YES;
        [_scaleButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleBtnDidPan:)]];
    }
    return _scaleButton;
}


@end

@interface WKCStickersTool()

@property (nonatomic, strong) UIImage * stickerImage;
@property (nonatomic, strong) UIImage * deleteImage;

@property (nonatomic, strong) WKCStickersItem * stickerItem;

@end

@implementation WKCStickersTool

#pragma mark ---<OutsideMethod>---

- (instancetype)initWithFrame:(CGRect)frame
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage {
    if (self = [super initWithFrame:frame]) {
        _stickerImage = sticker;
        _deleteImage = dImage;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.stickerItem];
        self.hidden = YES;
    }
    return self;
}

- (void)fireOn {
    [self.stickerItem setAcvitity:YES];
    self.stickerItem.center = self.center;
    self.hidden = NO;
}

- (void)fireOff {
    self.hidden = YES;
}

- (void)callBackEdited {
    
    [self.stickerItem setAcvitity:NO];
    
    __weak typeof(self)WeakSelf = self;
    
    [WKCCaptureTool captureView:self.superview.superview isSave:NO completionHandle:^(UIImage *image, BOOL isSuccess, NSError *error) {
        
        if (isSuccess) {
            if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(stickerTool:didFinishEditImage:)]) {
                [WeakSelf.delegate stickerTool:WeakSelf didFinishEditImage:image];
            }
        }else {
            if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(stickerTool:didFinishEditImage:)]) {
                [WeakSelf.delegate stickerTool:WeakSelf didFinishEditImage:nil];
            }
        }
        
        [WeakSelf fireOff];
    }];

}

- (void)refreshSticker:(UIImage *)sticker {
    [self.stickerItem refreshStickerImage:sticker];
}

#pragma mark ---<PrivateMethod>---

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

#pragma mark ---<Setter>---

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.stickerItem.borderColor = borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.stickerItem.borderWidth = borderWidth;
}

#pragma mark ---<Lazy init>---

- (WKCStickersItem *)stickerItem {
    if (!_stickerItem) {
        _stickerItem = [[WKCStickersItem alloc] initWithFrame:CGRectMake(0, 0, 80, 80) stickerImage:self.stickerImage deleteImage:self.deleteImage];
        _stickerItem.userInteractionEnabled = YES;
        _stickerItem.center = self.center;
        _stickerItem.borderWidth = 2;
        _stickerItem.borderColor = [UIColor blackColor];
    }
    return _stickerItem;
}
@end
