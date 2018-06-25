//
//  WKCFilterTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WKCFilterType) {
    
#pragma mark ---<常用>---
    /**怀旧*/
    WKCFilterTypeInstant = 0,
    /**黑白*/
    WKCFilterTypeNoir ,
    /**淡黑白*/
    WKCFilterTypeLightNoir ,
    /**灰白*/
    WKCFilterTypeTonal ,
    /**岁月*/
    WKCFilterTypeTransfer ,
    /**单色*/
    WKCFilterTypeMono ,
    /**褪色*/
    WKCFilterTypeFade ,
    /**冲印*/
    WKCFilterTypeProcess ,
    /**铭黄*/
    WKCFilterTypeChrome ,
    /**复古*/
    WKCFilterTypeSepiaTone ,
    /**古画*/
    WKCFilterTypeWeekPaiting ,
    /**阴影凸*/
    WKCFilterTypeBloom ,
    /**高能*/
    WKCFilterTypeHeightField ,
    /**微淡*/
    WKCFilterTypeWeekLight ,
    /**黑白点线条*/
    WKCFilterTypeHatched ,
    /**白黑点线条*/
    WKCFilterTypeDot ,
    /**聚光灯*/
    WKCFilterTypeSpotLight ,
    /**聚光颜色*/
    WKCFilterTypeSpotColor ,
    /**聚焦*/
    WKCFilterTypeVignette ,
    /**高速模糊*/
    WKCFilterTypeZoomBlur ,
    /**运动模糊*/
    WKCFilterTypeMotionBlur ,
    /**圆盘模糊*/
    WKCFilterTypeDiscBlur ,
    /**盒状模糊*/
    WKCFilterTypeBoxBlur ,
    /**假色*/
    WKCFilterTypeFalseColor ,
    
#pragma mark ---<特效>---
    /**圆盘*/
    WKCFilterTypeEffectCircular ,
    /**圆弧*/
    WKCFilterTypeEffectRaidus ,
    /**色调分离*/
    WKCFilterTypeEffectPosterize ,
    /**棱形*/
    WKCFilterTypeEffectLozenge ,
    /**直方图*/
    WKCFilterTypeEffectHistogram ,
    /**九格拉伸*/
    WKCFilterTypeEffectStretched ,
    /**九格瓷砖*/
    WKCFilterTypeEffectTiled ,
    /**伸展*/
    WKCFilterTypeEffectStretchCrop ,
    /**音曲线*/
    WKCFilterTypeEffectToneCurve ,
    /**线性音曲线*/
    WKCFilterTypeEffectLinearToneCurve ,
    /**X射线*/
    WKCFilterTypeEffectXRay ,
    /**热能*/
    WKCFilterTypeEffectThermal ,
    /**半色调*/
    WKCFilterTypeEffectHalftone ,
    /**点黑白*/
    WKCFilterTypeEffectEdges ,
    /**滑稽*/
    WKCFilterTypeEffectComic ,
    /**单色调*/
    WKCFilterTypeEffectMonochrome ,
    /**色调倒置*/
    WKCFilterTypeEffectColorInvert ,
    /**点状化*/
    WKCFilterTypeEffectPointillize ,
    /**像素化*/
    WKCFilterTypeEffectPixellate ,
    /**六角形像素化*/
    WKCFilterTypeEffectHexagonalPixellate ,
    /**透视转换*/
    WKCFilterTypeEffectPerspectiveExtent ,
    /**透视转移*/
    WKCFilterTypeEffectPerspectiveTransform ,
    /**透视更正*/
    WKCFilterTypeEffectPerspectiveCorrection ,
    /**万花筒*/
    WKCFilterTypeEffectKaleidoscope ,
    /**结晶*/
    WKCFilterTypeEffectCrystallize ,
    
#pragma mark ---<失真>---
    /**漩涡失真*/
    WKCFilterTypeDistortionTwirl ,
    /**涡旋失真*/
    WKCFilterTypeDistortionVortex ,
    /**花瓣*/
    WKCFilterTypeDistortionTorusLens ,
    /**捏合失真*/
    WKCFilterTypeDistortionPinch ,
    /**洞状失真*/
    WKCFilterTypeDistortionHole ,
    /**磕碰失真*/
    WKCFilterTypeDistortionBump ,
};

@class WKCFilterTool;

@protocol WKCFilterToolDelegate<NSObject>

@optional

- (void)filterTool:(WKCFilterTool *)tool
      editingImage:(UIImage *)editing;

- (void)filterTool:(WKCFilterTool *)tool
 didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCFilterTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCFilterToolDelegate> delegate;
/**类型 - 默认怀旧*/
@property (nonatomic, assign) WKCFilterType filterType;

/**初始化 - 默认fireOn*/
- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image;

/**刷新源图*/
- (void)refreshOrigin:(UIImage *)origin;
/**开启*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;

/**回调编辑完的*/
- (void)callBackEdited;
@end
