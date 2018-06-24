//
//  WKCCaptureTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCCaptureTool.h"
#import <Photos/Photos.h>

@implementation WKCCaptureTool

+ (void)saveImage:(UIImage *)image
 completionHandle:(void(^)(BOOL isSuccess,NSError *error))handle {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        NSLog(@"%@",req);
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        handle(success,error);
    }];
}

+ (UIImage *)captureView:(UIView *)view
                  isSave:(BOOL)save
        completionHandle:(void(^)(BOOL isSuccess,NSError *error))handle {
    CGRect frame = view.frame;
    UIGraphicsBeginImageContext(frame.size);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (save) {
        [self saveImage:image completionHandle:^(BOOL isSuccess, NSError *error) {
            handle(isSuccess, error);
        }];
    }else {
        handle(YES, nil);
    }
    return image;
}

+ (UIImage *)captureRect:(CGRect)rect fullImage:(UIImage *)full isSave:(BOOL)save completionHandle:(void (^)(BOOL, NSError *))handle {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x =  rect.origin.x * scale, y = rect.origin.y * scale, w = rect.size.width * scale, h = rect.size.height * scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    CGImageRef sourceImageRef = [full CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    if (save) {
        [self saveImage:newImage completionHandle:^(BOOL isSuccess, NSError *error) {
            handle(isSuccess, error);
        }];
    }else {
        handle(YES, nil);
    }
    return newImage;
}

@end
