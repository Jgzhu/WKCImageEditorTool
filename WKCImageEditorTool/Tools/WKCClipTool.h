//
//  WKCClipTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/24.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCClipTool;

@protocol WKCClipToolDelegate<NSObject>

- (void)clipTool:(WKCClipTool *)tool
didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCClipTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCClipToolDelegate> delegate;

/**网格及球颜色 -- 默认白色*/
@property (nonatomic, strong) UIColor * gridColor;
/**网格背景色 -- 默认黑色*/
@property (nonatomic, strong) UIColor * gridBgColor;

/**
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image;

/**刷新源图*/
- (void)refreshOrigin:(UIImage *)origin;
/**刷新比例*/
- (void)refreshScale:(CGFloat)scale
           animation:(BOOL)animation;
/**开启*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**代理回调*/
- (void)callBack;

@end
