//
//  WKCRotationTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCRotationTool.h"
#import "UIImage+rotationTool.h"
@interface WKCRotationTool()

@property (nonatomic, strong) UIImage * origin;
@end

@implementation WKCRotationTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.origin = image;
        self.rotationType = WKCImageRotationTypeOrientationLeft;
        self.hidden = YES;
    }
    return self;
}

- (void)callBack {
    switch (self.rotationType) {
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
    [self postDelegate];
}

- (void)postDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rotationTool:didFinishEditImage:)]) {
        [self.delegate rotationTool:self didFinishEditImage:self.origin];
    }
}

@end
