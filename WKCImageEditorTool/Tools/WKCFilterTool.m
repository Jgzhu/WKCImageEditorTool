//
//  WKCFilterTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCFilterTool.h"
#import "WKCFilterManager.h"
#import "WKCCache.h"

@interface WKCFilterTool()

@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImage * tmpImage;
@end

@implementation WKCFilterTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.image = image;
        self.hidden = YES;
    }
    return self;
}

- (void)setFilterType:(WKCFilterType)filterType {
    _filterType = filterType;

    switch (filterType) {
        case WKCFilterTypeFade:
            self.fileName = @"CIPhotoEffectFade";
            break;
        case WKCFilterTypeMono:
            self.fileName = @"CIPhotoEffectMono";
            break;
        case WKCFilterTypeNoir:
            self.fileName = @"CIPhotoEffectNoir";
            break;
        case WKCFilterTypeTonal:
            self.fileName = @"CIPhotoEffectTonal";
            break;
        case WKCFilterTypeChrome:
            self.fileName = @"CIPhotoEffectChrome";
            break;
        case WKCFilterTypeInstant:
            self.fileName = @"CIPhotoEffectInstant";
            break;
        case WKCFilterTypeProcess:
            self.fileName = @"CIPhotoEffectProcess";
            break;
        case WKCFilterTypeTransfer:
            self.fileName = @"CIPhotoEffectTransfer";
            break;
        case WKCFilterTypeSepiaTone:
            self.fileName = @"CISepiaTone";
            break;
        case WKCFilterTypeLightNoir:
            self.fileName = @"CIMinimumComponent";
            break;
        case WKCFilterTypeBloom:
            self.fileName = @"CIBloom";
            break;
        case WKCFilterTypeHeightField:
            self.fileName = @"CIHeightFieldFromMask";
            break;
        case WKCFilterTypeWeekLight:
            self.fileName = @"CILinearToSRGBToneCurve";
            break;
        case WKCFilterTypeWeekPaiting:
            self.fileName = @"CILineOverlay";
            break;
        case WKCFilterTypeHatched:
            self.fileName = @"CIHatchedScreen";
            break;
        case WKCFilterTypeDot:
            self.fileName = @"CIDotScreen";
            break;
        case WKCFilterTypeSpotLight:
            self.fileName = @"CISpotLight";
            break;
        case WKCFilterTypeSpotColor:
            self.fileName = @"CISpotColor";
            break;
        case WKCFilterTypeVignette:
            self.fileName = @"CIVignetteEffect";
            break;
        case WKCFilterTypeZoomBlur:
            self.fileName = @"CIZoomBlur";
            break;
        case WKCFilterTypeMotionBlur:
            self.fileName = @"CIMotionBlur";
            break;
        case WKCFilterTypeDiscBlur:
            self.fileName = @"CIDiscBlur";
            break;
        case WKCFilterTypeBoxBlur:
            self.fileName = @"CIBoxBlur";
            break;
        case WKCFilterTypeFalseColor:
            self.fileName = @"CIFalseColor";
            break;
        case WKCFilterTypeEffectCircular:
            self.fileName = @"CICircularScreen";
            break;
        case WKCFilterTypeEffectRaidus:
            self.fileName = @"CICircularWrap";
            break;
        case WKCFilterTypeEffectPosterize:
            self.fileName = @"CIColorPosterize";
            break;
        case WKCFilterTypeEffectLozenge:
            self.fileName = @"CIGlassLozenge";
            break;
        case WKCFilterTypeEffectHistogram:
            self.fileName = @"CIHistogramDisplayFilter";
            break;
        case WKCFilterTypeEffectStretched:
            self.fileName = @"CINinePartStretched";
            break;
        case WKCFilterTypeEffectTiled:
            self.fileName = @"CINinePartTiled";
            break;
        case WKCFilterTypeEffectStretchCrop:
            self.fileName = @"CIStretchCrop";
            break;
        case WKCFilterTypeEffectToneCurve:
            self.fileName = @"CIToneCurve";
            break;
        case WKCFilterTypeEffectLinearToneCurve:
           self.fileName = @"CISRGBToneCurveToLinear";
            break;
        case WKCFilterTypeEffectXRay:
           self.fileName = @"CIXRay";
            break;
        case WKCFilterTypeEffectThermal:
            self.fileName = @"CIThermal";
            break;
        case WKCFilterTypeEffectHalftone:
            self.fileName = @"CICMYKHalftone";
            break;
        case WKCFilterTypeEffectEdges:
            self.fileName = @"CIEdges";
            break;
        case WKCFilterTypeEffectComic:
            self.fileName = @"CIComicEffect";
            break;
        case WKCFilterTypeEffectMonochrome:
            self.fileName = @"CIColorMonochrome";
            break;
        case WKCFilterTypeEffectColorInvert:
            self.fileName = @"CIColorInvert";
            break;
        case WKCFilterTypeEffectPointillize:
            self.fileName = @"CIPointillize";
            break;
        case WKCFilterTypeEffectPixellate:
            self.fileName = @"CIPixellate";
            break;
        case WKCFilterTypeEffectHexagonalPixellate:
            self.fileName = @"CIHexagonalPixellate";
            break;
        case WKCFilterTypeEffectPerspectiveExtent:
            self.fileName = @"CIPerspectiveTransformWithExtent";
            break;
        case WKCFilterTypeEffectPerspectiveTransform:
            self.fileName = @"CIPerspectiveTransform";
            break;
        case WKCFilterTypeEffectPerspectiveCorrection:
            self.fileName = @"CIPerspectiveCorrection";
            break;
        case WKCFilterTypeEffectKaleidoscope:
            self.fileName = @"CIKaleidoscope";
            break;
        case WKCFilterTypeEffectCrystallize:
            self.fileName = @"CICrystallize";
            break;
        case WKCFilterTypeDistortionTwirl:
            self.fileName = @"CITwirlDistortion";
            break;
        case WKCFilterTypeDistortionVortex:
            self.fileName = @"CIVortexDistortion";
            break;
        case WKCFilterTypeDistortionTorusLens:
            self.fileName = @"CITorusLensDistortion";
            break;
        case WKCFilterTypeDistortionPinch:
            self.fileName = @"CIPinchDistortion";
            break;
        case WKCFilterTypeDistortionHole:
            self.fileName = @"CIHoleDistortion";
            break;
        case WKCFilterTypeDistortionBump:
            self.fileName = @"CIBumpDistortion";
            break;
        default:
            break;
    }
    
   UIImage *cacheImage = [WKCCache imageForKey:self.fileName];
    
    if (cacheImage) {
        _tmpImage = cacheImage;
    }else {
        
        __weak typeof(self)WeakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           self.image = [WKCCache forceAnalyzeSourceImage:self.image];
            [WKCFilterManager filterWithName:self.fileName originImage:self.image completationHandle:^(UIImage *image) {
                if (image) {
                WeakSelf.tmpImage = [WKCCache forceAnalyzeSourceImage:image];
                [WKCCache cacheSourceImage:WeakSelf.tmpImage forKey:WeakSelf.fileName];
                    [WeakSelf callBackEditing];
                }
            }];
        });
    }
    
}

- (void)fireOn {
    self.hidden = NO;
}

-(void)fireOff {
    self.hidden = YES;
}

- (void)refreshOrigin:(UIImage *)origin {
    self.image = origin;
    [self setFilterType:self.filterType];
}

- (void)callBackEditing {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTool:editingImage:)]) {
            [self.delegate filterTool:self editingImage:self.tmpImage];
        }
    });
}

-(void)callBackEdited {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTool:didFinishEditImage:)]) {
            [self.delegate filterTool:self didFinishEditImage:self.tmpImage];
        }
    });
}


@end
