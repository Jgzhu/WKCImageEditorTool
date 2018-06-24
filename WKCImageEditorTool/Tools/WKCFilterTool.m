//
//  WKCFilterTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCFilterTool.h"
#import "WKCFilterManager.h"

@interface WKCFilterTool(){
    UIImage *_tmpImage;
}

@property (nonatomic, strong) UIImage * image;

@end

@implementation WKCFilterTool

- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.image = image;
        self.filterType = WKCFilterTypeInstant;
        self.hidden = YES;
    }
    return self;
}

- (void)setFilterType:(WKCFilterType)filterType {
    _filterType = filterType;
    NSString *fileName = nil;
    switch (filterType) {
        case WKCFilterTypeFade:
            fileName = @"CIPhotoEffectFade";
            break;
        case WKCFilterTypeMono:
            fileName = @"CIPhotoEffectMono";
            break;
        case WKCFilterTypeNoir:
            fileName = @"CIPhotoEffectNoir";
            break;
        case WKCFilterTypeTonal:
            fileName = @"CIPhotoEffectTonal";
            break;
        case WKCFilterTypeChrome:
            fileName = @"CIPhotoEffectChrome";
            break;
        case WKCFilterTypeInstant:
            fileName = @"CIPhotoEffectInstant";
            break;
        case WKCFilterTypeProcess:
            fileName = @"CIPhotoEffectProcess";
            break;
        case WKCFilterTypeTransfer:
            fileName = @"CIPhotoEffectTransfer";
            break;
        case WKCFilterTypeSepiaTone:
            fileName = @"CISepiaTone";
            break;
        case WKCFilterTypeLightNoir:
            fileName = @"CIMinimumComponent";
            break;
        case WKCFilterTypeBloom:
            fileName = @"CIBloom";
            break;
        case WKCFilterTypeHeightField:
            fileName = @"CIHeightFieldFromMask";
            break;
        case WKCFilterTypeWeekLight:
            fileName = @"CILinearToSRGBToneCurve";
            break;
        case WKCFilterTypeWeekPaiting:
            fileName = @"CILineOverlay";
            break;
        case WKCFilterTypeHatched:
            fileName = @"CIHatchedScreen";
            break;
        case WKCFilterTypeDot:
            fileName = @"CIDotScreen";
            break;
        case WKCFilterTypeSpotLight:
            fileName = @"CISpotLight";
            break;
        case WKCFilterTypeSpotColor:
            fileName = @"CISpotColor";
            break;
        case WKCFilterTypeVignette:
            fileName = @"CIVignetteEffect";
            break;
        case WKCFilterTypeZoomBlur:
            fileName = @"CIZoomBlur";
            break;
        case WKCFilterTypeMotionBlur:
            fileName = @"CIMotionBlur";
            break;
        case WKCFilterTypeDiscBlur:
            fileName = @"CIDiscBlur";
            break;
        case WKCFilterTypeBoxBlur:
            fileName = @"CIBoxBlur";
            break;
        case WKCFilterTypeFalseColor:
            fileName = @"CIFalseColor";
            break;
        case WKCFilterTypeEffectCircular:
            fileName = @"CICircularScreen";
            break;
        case WKCFilterTypeEffectRaidus:
            fileName = @"CICircularWrap";
            break;
        case WKCFilterTypeEffectPosterize:
            fileName = @"CIColorPosterize";
            break;
        case WKCFilterTypeEffectLozenge:
            fileName = @"CIGlassLozenge";
            break;
        case WKCFilterTypeEffectHistogram:
            fileName = @"CIHistogramDisplayFilter";
            break;
        case WKCFilterTypeEffectStretched:
            fileName = @"CINinePartStretched";
            break;
        case WKCFilterTypeEffectTiled:
            fileName = @"CINinePartTiled";
            break;
        case WKCFilterTypeEffectStretchCrop:
            fileName = @"CIStretchCrop";
            break;
        case WKCFilterTypeEffectToneCurve:
            fileName = @"CIToneCurve";
            break;
        case WKCFilterTypeEffectLinearToneCurve:
           fileName = @"CISRGBToneCurveToLinear";
            break;
        case WKCFilterTypeEffectXRay:
           fileName = @"CIXRay";
            break;
        case WKCFilterTypeEffectThermal:
            fileName = @"CIThermal";
            break;
        case WKCFilterTypeEffectHalftone:
            fileName = @"CICMYKHalftone";
            break;
        case WKCFilterTypeEffectEdges:
            fileName = @"CIEdges";
            break;
        case WKCFilterTypeEffectComic:
            fileName = @"CIComicEffect";
            break;
        case WKCFilterTypeEffectMonochrome:
            fileName = @"CIColorMonochrome";
            break;
        case WKCFilterTypeEffectColorInvert:
            fileName = @"CIColorInvert";
            break;
        case WKCFilterTypeEffectPointillize:
            fileName = @"CIPointillize";
            break;
        case WKCFilterTypeEffectPixellate:
            fileName = @"CIPixellate";
            break;
        case WKCFilterTypeEffectHexagonalPixellate:
            fileName = @"CIHexagonalPixellate";
            break;
        case WKCFilterTypeEffectPerspectiveExtent:
            fileName = @"CIPerspectiveTransformWithExtent";
            break;
        case WKCFilterTypeEffectPerspectiveTransform:
            fileName = @"CIPerspectiveTransform";
            break;
        case WKCFilterTypeEffectPerspectiveCorrection:
            fileName = @"CIPerspectiveCorrection";
            break;
        case WKCFilterTypeEffectKaleidoscope:
            fileName = @"CIKaleidoscope";
            break;
        case WKCFilterTypeEffectCrystallize:
            fileName = @"CICrystallize";
            break;
        case WKCFilterTypeDistortionTwirl:
            fileName = @"CITwirlDistortion";
            break;
        case WKCFilterTypeDistortionVortex:
            fileName = @"CIVortexDistortion";
            break;
        case WKCFilterTypeDistortionTorusLens:
            fileName = @"CITorusLensDistortion";
            break;
        case WKCFilterTypeDistortionPinch:
            fileName = @"CIPinchDistortion";
            break;
        case WKCFilterTypeDistortionHole:
            fileName = @"CIHoleDistortion";
            break;
        case WKCFilterTypeDistortionBump:
            fileName = @"CIBumpDistortion";
            break;
        default:
            break;
    }
    
    _tmpImage = [WKCFilterManager filterWithName:fileName originImage:self.image];
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
    [self callBack];
}

-(void)callBackEdited {
    [self callBack];
}

- (void)callBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterTool:didFinishEditImage:)]) {
        [self.delegate filterTool:self didFinishEditImage:_tmpImage];
    }
}

@end
