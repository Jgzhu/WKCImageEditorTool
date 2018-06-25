//
//  WKCBrightTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCBrightTool.h"
#import "WKCFilterManager.h"
#import "WKCCache.h"
@interface WKCBrightTool() {
    WKCBrightType _tmpType;
    CGFloat _tmpVaule;
}

@property (nonatomic, strong) UIImage * tmpImage;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) CIFilter *filter;

@end

@implementation WKCBrightTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.image = image;
        _tmpImage = image;
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

- (void)brightWithType:(WKCBrightType)type value:(CGFloat)value {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        switch (type) {
            case WKCBrightTypeLight:
                self.image = [WKCCache forceAnalyzeSourceImage:self.image];
                self.tmpImage = [WKCFilterManager brightFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
                self.tmpImage = [WKCCache forceAnalyzeSourceImage:self.tmpImage];
                break;
            case WKCBrightTypeSaturation:
                 self.image = [WKCCache forceAnalyzeSourceImage:self.image];
                self.tmpImage = [WKCFilterManager saturationFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
                 self.tmpImage = [WKCCache forceAnalyzeSourceImage:self.tmpImage];
                break;
            case WKCBrightTypeContrast:
                self.image = [WKCCache forceAnalyzeSourceImage:self.image];
                self.tmpImage = [WKCFilterManager contrastFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
                self.tmpImage = [WKCCache forceAnalyzeSourceImage:self.tmpImage];
                break;
            default:
                break;
        }
    });

    _tmpType = type;
    _tmpVaule = value;
    
}

- (void)refreshOrigin:(UIImage *)origin {
    self.image = origin;
    [self brightWithType:_tmpType value:_tmpVaule];
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (void)callBackEditing {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(brightTool:editingImage:)]) {
            [self.delegate brightTool:self editingImage:self.tmpImage];
        }
    });
}

- (void)callBackEdited {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(brightTool:didFinishEditImage:)]) {
            [self.delegate brightTool:self didFinishEditImage:self.tmpImage];
        }
    });
}

@end
