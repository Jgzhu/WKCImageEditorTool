//
//  WKCStickersTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCStickersTool;

@protocol WKCStickersToolDelegate<NSObject>

- (void)stickerTool:(WKCStickersTool *)tool
 didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCStickersTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCStickersToolDelegate> delegate;

#pragma mark ---<边框>---
/**边框颜色 - 默认黑色*/
@property (nonatomic, strong) UIColor * borderColor;
/**边框宽度 - 默认2*/
@property (nonatomic, assign) CGFloat borderWidth;

/**初始化*/
- (instancetype)initWithFrame:(CGRect)frame
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage;

/**刷新贴图*/
- (void)refreshSticker:(UIImage *)sticker;
/**开启使用*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**代理回调*/
- (void)callBackEdited;

@end
