//
//  WKCBrightTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WKCBrightType) {
    /**亮度*/
    WKCBrightTypeLight = 0,
    /**饱和度*/
    WKCBrightTypeSaturation = 1,
    /**对比度*/
    WKCBrightTypeContrast = 2
};

@class WKCBrightTool;

@protocol WKCBrightToolDelegate<NSObject>

- (void)brightTool:(WKCBrightTool *)tool
      editingImage:(UIImage *)editing;

- (void)brightTool:(WKCBrightTool *)tool
didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCBrightTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCBrightToolDelegate> delegate;

/**初始化*/
- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image;

/**调 - 度*/
- (void)brightWithType:(WKCBrightType)type
                 value:(CGFloat)value;
/**刷新*/
- (void)refreshOrigin:(UIImage *)origin;

/**回调正在编辑*/
- (void)callBackEditing;
/**回调编辑完的*/
- (void)callBackEdited;
/**开启*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
@end
