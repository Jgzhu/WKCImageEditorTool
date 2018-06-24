//
//  WKCBrightTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCBrightTool.h"
#import "WKCFilterManager.h"

@interface WKCBrightTool() {
    WKCBrightType _tmpType;
    CGFloat _tmpVaule;
    UIImage *_tmpImage;
}

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
    switch (type) {
        case WKCBrightTypeLight:
           _tmpImage = [WKCFilterManager brightFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
            break;
        case WKCBrightTypeSaturation:
           _tmpImage = [WKCFilterManager saturationFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
            break;
        case WKCBrightTypeContrast:
           _tmpImage = [WKCFilterManager contrastFilter:[WKCFilterManager brightWithOriginImage:self.image] value:value];
            break;
        default:
            break;
    }
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

- (void)callBack {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(brightTool:didFinishEditImage:)]) {
        [self.delegate brightTool:self didFinishEditImage:_tmpImage];
    }
}

@end
