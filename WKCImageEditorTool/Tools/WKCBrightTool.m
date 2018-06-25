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
        self.image = [WKCCache forceAnalyzeSourceImage:self.image];
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (type) {
                case WKCBrightTypeLight:
                    self.tmpImage = [WKCFilterManager brightFilter:self.filter value:value];
                    break;
                case WKCBrightTypeSaturation:
                    self.tmpImage = [WKCFilterManager saturationFilter:self.filter value:value];
                    break;
                case WKCBrightTypeContrast:
                    self.tmpImage = [WKCFilterManager contrastFilter:self.filter value:value];
                    break;
                default:
                    break;
            }
        });
        self.tmpImage = [WKCCache forceAnalyzeSourceImage:self.tmpImage];
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

- (CIFilter *)filter {
    if (!_filter) {
        _filter = [WKCFilterManager brightWithOriginImage:self.image];
    }
    return _filter;
}
@end
