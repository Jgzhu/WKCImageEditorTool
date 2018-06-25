//
//  WKCCache.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/25.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCCache.h"

@implementation WKCCache


+ (void)cacheSourceImage:(UIImage *)image forKey:(NSString *)key {
    WKCCache *cahche = [[WKCCache alloc] init];
    [cahche setObject:image forKey:key];
}

+ (UIImage *)imageForKey:(NSString *)key {
    WKCCache *cahche = [[WKCCache alloc] init];
    return [cahche objectForKey:key];
}


- (id)valueForUndefinedKey:(NSString *)key {
    [super valueForUndefinedKey:key];
    return nil;
}

+ (UIImage *)forceAnalyzeSourceImage:(UIImage *)source {
    
    @autoreleasepool {
        CGImageRef imageRef = source.CGImage;
        
        CGColorSpaceRef colorspaceRef = [self colorSpaceForImageRef:imageRef];
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     8,
                                                     0,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        if (context == NULL) {
            return source;
        }
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        
        CGImageRef newImageRef = CGBitmapContextCreateImage(context);
        
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef
                                                scale:source.scale
                                          orientation:source.imageOrientation];
        
        CGContextRelease(context);
        CGImageRelease(newImageRef);
        
        return newImage;
    }
    
}


+ (CGColorSpaceRef)colorSpaceForImageRef:(CGImageRef)imageRef {
    // current
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = SDCGColorSpaceGetDeviceRGB();
    }
    return colorspaceRef;
}

CGColorSpaceRef SDCGColorSpaceGetDeviceRGB(void) {
    static CGColorSpaceRef colorSpace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpace;
}

@end
