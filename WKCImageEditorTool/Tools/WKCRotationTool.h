//
//  WKCRotationTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WKCImageRotationType) {
    /**90度逆时针*/
    WKCImageRotationTypeOrientationLeft = 0,
    /**90度顺时针*/
    WKCImageRotationTypeOrientationRight = 1,
    /**180度顺时针*/
    WKCImageRotationTypeOrientationDown = 2,
    /**水平翻转*/
    WKCImageRotationTypeFlipHorizontal = 3,
    /**垂直翻转*/
    WKCImageRotationTypeFlipVertical = 4,
    /**逆时针翻页*/
    WKCImageRotationTypePageLeft = 5,
    /**顺时针翻页*/
    WKCImageRotationTypePageRight = 6,
    /**固定角度旋转*/
    WKCImageRotationTypeDegrees = 7,
    /**固定弧度*/
    WKCImageRotationTypeRadius = 8
};

@class WKCRotationTool;

@protocol WKCRotationToolDelegate<NSObject>

@optional

- (void)rotationTool:(WKCRotationTool *)tool
        editingImage:(UIImage *)editing;

- (void)rotationTool:(WKCRotationTool *)tool
  didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCRotationTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCRotationToolDelegate> delegate;
/**模式 - 默认90度逆时针*/
@property (nonatomic, assign) WKCImageRotationType rotationType;
/**值 - 只在角度和弧度旋转下有效*/
@property (nonatomic, assign) CGFloat value;

/**初始化 - 90度逆时针*/
- (instancetype)initWithFrame:(CGRect)frame
                  originImage:(UIImage *)image;

/**刷新源图*/
- (void)refreshOrigin:(UIImage *)origin;
/**开启*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**回调正在编辑的*/
- (void)callBackEditing;
/**回调编辑完的*/
- (void)callBackEdited;
@end
