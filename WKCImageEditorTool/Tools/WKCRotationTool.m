//
//  WKCRotationTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCRotationTool.h"
#import "UIImage+rotationTool.h"
#import "WKCCache.h"

@interface WKCRotationTool()

@property (nonatomic, strong) UIImage * origin;
@end

@implementation WKCRotationTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.rotationType = WKCImageRotationTypeOrientationLeft;
        self.origin = image;
        self.hidden = YES;
    }
    return self;
}

- (void)setRotationType:(WKCImageRotationType)rotationType {
    _rotationType = rotationType;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        switch (rotationType) {
            case WKCImageRotationTypeOrientationLeft:
            {
                self.origin = [self.origin rotate:UIImageOrientationLeft];
            }
                break;
            case WKCImageRotationTypeOrientationRight:
            {
                self.origin = [self.origin rotate:UIImageOrientationRight];
            }
                break;
            case WKCImageRotationTypeOrientationDown:
            {
                self.origin = [self.origin rotate:UIImageOrientationDown];
            }
                break;
            case WKCImageRotationTypeFlipVertical:
            {
                self.origin = [self.origin rotate:UIImageOrientationDownMirrored];
            }
                break;
            case WKCImageRotationTypeFlipHorizontal:
            {
                self.origin = [self.origin rotate:UIImageOrientationUpMirrored];
            }
                break;
            case WKCImageRotationTypePageLeft:
            {
                self.origin = [self.origin rotate:UIImageOrientationLeftMirrored];
            }
                break;
            case WKCImageRotationTypePageRight:
            {
                self.origin = [self.origin rotate:UIImageOrientationRightMirrored];
            }
                break;
            case WKCImageRotationTypeDegrees:
            {
                self.origin = [self.origin imageRotatedByDegrees:self.value];
            }
                break;
            case WKCImageRotationTypeRadius:
            {
                self.origin = [self.origin imageRotatedByRadians:self.value];
            }
                break;
            default:
                break;
        }
    });

}

- (void)callBackEditing {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotationTool:editingImage:)]) {
            [self.delegate rotationTool:self editingImage:self.origin];
        }
    });
}

- (void)callBackEdited {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotationTool:didFinishEditImage:)]) {
            [self.delegate rotationTool:self didFinishEditImage:self.origin];
        }
    });
}

- (void)fireOn {
    self.hidden = NO;
}

- (void)fireOff {
    self.hidden = YES;
}

- (void)refreshOrigin:(UIImage *)origin {
    self.origin = origin;
}

@end
