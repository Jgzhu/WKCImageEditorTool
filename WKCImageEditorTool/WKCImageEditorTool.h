//
//  WKCImageEditorTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/24.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCFilterTool.h"
#import "WKCRotationTool.h"
#import "WKCDrawTool.h"
#import "WKCStickersTool.h"
#import "WKCMosaicTool.h"
#import "WKCTextTool.h"
#import "WKCBrightTool.h"
#import "WKCClipTool.h"

typedef NS_ENUM(NSInteger,WKCImageEditorToolType) {
    /**滤镜*/
    WKCImageEditorToolTypeFilter = 0,
    /**旋转*/
    WKCImageEditorToolTypeRotation = 1,
    /**画笔*/
    WKCImageEditorToolTypeDraw = 2,
    /**贴图*/
    WKCImageEditorToolTypeSticker = 3,
    /**马赛克*/
    WKCImageEditorToolTypeMosaic = 4,
    /**文本*/
    WKCImageEditorToolTypeText = 5,
    /**亮度*/
    WKCImageEditorToolTypeBright = 6,
    /**裁剪*/
    WKCImageEditorToolTypeClip = 7,
};

@class WKCImageEditorTool;

@protocol WKCImageEditorToolDelegate<NSObject>

/**
 *编辑中的图片 - 展示效果用
 */
- (void)imageEditorTool:(WKCImageEditorTool *)tool
           editingImage:(UIImage *)editing;

/**
 *编辑确认的图片
 */
- (void)imageEditorTool:(WKCImageEditorTool *)tool
     editedImage:(UIImage *)edited;

@end

@interface WKCImageEditorTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCImageEditorToolDelegate> delegate;
/**工具类型 - 默认滤镜*/
@property (nonatomic, assign) WKCImageEditorToolType editorType;
/**源图*/
@property (nonatomic, strong) UIImage * sourceImage;

/**滤镜工具*/
@property (nonatomic, strong) WKCFilterTool * filterTool;
/**旋转工具*/
@property (nonatomic, strong) WKCRotationTool * rotationTool;
/**画笔工具*/
@property (nonatomic, strong) WKCDrawTool * drawTool;
/**贴图工具*/
@property (nonatomic, strong) WKCStickersTool * stickerTool;
/**马赛克工具*/
@property (nonatomic, strong) WKCMosaicTool * mosaicTool;
/**文本工具*/
@property (nonatomic, strong) WKCTextTool * textTool;
/**亮度工具*/
@property (nonatomic, strong) WKCBrightTool * brightTool;
/**裁剪工具*/
@property (nonatomic, strong) WKCClipTool * clipTool;

/**
 *普通初始化 - 亮度、滤镜、旋转、画笔、马赛克、裁剪模式
 */
- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source;
/**
 *普通模式 + 贴图模式的初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage;
/**
 *普通模式 + 文本模式的初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                   textDelete:(UIImage *)tImage;

/**
 *全模式
 */
- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage
                   textDelete:(UIImage *)tImage;

/**开启使用*/
- (void)fire;
/**确认*/
- (void)confirm;
/**取消*/
- (void)cancel;


@end
