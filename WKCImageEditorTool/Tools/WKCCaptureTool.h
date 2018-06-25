//
//  WKCCaptureTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCCaptureTool : NSObject

/**保存到图库*/
+ (void)saveImage:(UIImage *)image
 completionHandle:(void(^)(BOOL isSuccess,NSError *error))handle;

/**截屏 - 视图*/
+ (void)captureView:(UIView *)view
             isSave:(BOOL)save
   completionHandle:(void(^)(UIImage *image,BOOL isSuccess,NSError *error))handle;

/**截屏 - 源图范围内*/
+ (void)captureRect:(CGRect)rect fullImage:(UIImage *)full isSave:(BOOL)save completionHandle:(void (^)(UIImage *image,BOOL isSuccess, NSError *error))handle;
@end
