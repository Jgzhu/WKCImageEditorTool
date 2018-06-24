//
//  WKCFilterTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCFilterManager.h"
#import <CoreImage/CIFilter.h>

@implementation WKCFilterManager
+ (UIImage *)filterWithName:(NSString *)name
                originImage:(UIImage *)image {
    
    CIImage *ciImage =[[CIImage alloc]initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:name keysAndValues:kCIInputImageKey,ciImage,nil];
    
    [filter setDefaults];
    
    CIContext *context =[CIContext contextWithOptions:nil];
    
    CIImage *outputImage =[filter outputImage];
    
    CGImageRef cgImage =[context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newimage =[UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return newimage;
}


+ (CIFilter *)brightWithOriginImage:(UIImage *)image {
    return [self baseFilterWithName:@"CIColorControls" originImage:image];
}

+ (UIImage *)brightFilter:(CIFilter *)filter
                    value:(CGFloat)value {
    return [self baseSetValueFilter:filter value:value key:@"inputBrightness"];
}

+ (UIImage *)saturationFilter:(CIFilter *)filter
                        value:(CGFloat)value {
    return [self baseSetValueFilter:filter value:value key:@"inputSaturation"];
}

+ (UIImage *)contrastFilter:(CIFilter *)filter
                      value:(CGFloat)value {
    return [self baseSetValueFilter:filter value:value key:@"inputContrast"];
}


+ (UIImage *)mosaicFilterWithOriginImage:(UIImage *)image {
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:ciImage  forKey:kCIInputImageKey];
    [filter setDefaults];
    CIImage *outImage = [filter           valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return showImage;
    
}


+ (CIFilter *)baseFilterWithName:(NSString *)name
                     originImage:(UIImage *)image {
    CIImage *ciImage =[[CIImage alloc]initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:name keysAndValues:kCIInputImageKey,ciImage,nil];
    
    [filter setValue:ciImage forKey:@"inputImage"];
    
    return filter;
}

+ (UIImage *)baseSetValueFilter:(CIFilter *)filter
                          value:(CGFloat)value
                            key:(NSString *)key {
    [filter setValue:[NSNumber numberWithFloat:value] forKey:key];
    
    CIContext *context =[CIContext contextWithOptions:nil];
    
    CIImage *outputImage =[filter outputImage];
    
    CGImageRef cgImage =[context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newimage =[UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return newimage;
}


@end
