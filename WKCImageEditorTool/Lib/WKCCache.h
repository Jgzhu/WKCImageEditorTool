//
//  WKCCache.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/25.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCCache : NSCache

+ (void)cacheSourceImage:(UIImage *)image
                  forKey:(NSString *)key;

+ (UIImage *)imageForKey:(NSString *)key;

/**
 *强制解析图片
 */
+ (UIImage *)forceAnalyzeSourceImage:(UIImage *)source;

@end
