//
//  WKCFilterTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCFilterManager : NSObject

/**
 * name 例如:
 @"CIPhotoEffectChrome",
 @"CIPhotoEffectFade",
 @"CIPhotoEffectInstant",
 @"CIPhotoEffectMono",
 @"CIPhotoEffectNoir",
 @"CIPhotoEffectProcess",
 @"CIPhotoEffectTonal",
 @"CIPhotoEffectTransfer"
 }
 */
#pragma mark ----<滤镜>----
/**滤镜*/
+ (void)filterWithName:(NSString *)name
           originImage:(UIImage *)image completationHandle:(void(^)(UIImage *image))handle;


#pragma mark ----<色彩>---
/**根据原图获得色彩调节滤镜*/
+ (CIFilter *)brightWithOriginImage:(UIImage *)image;
/**改变亮度值*/
+ (UIImage *)brightFilter:(CIFilter *)filter
                    value:(CGFloat)value;
/**改变饱和度值*/
+ (UIImage *)saturationFilter:(CIFilter *)filter
                        value:(CGFloat)value;
/**改变对比度值*/
+ (UIImage *)contrastFilter:(CIFilter *)filter
                      value:(CGFloat)value;

#pragma mark ----<马赛克>-----

+ (UIImage *)mosaicFilterWithOriginImage:(UIImage *)image;


@end
