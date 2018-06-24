//
//  WKCTextTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCTextTool;

@protocol WKCTextToolDelegate<NSObject>

- (void)textTool:(WKCTextTool *)tool
didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCTextTool : UIView

@property (nonatomic, weak) id<WKCTextToolDelegate> delegate;


/**文本 - 默认(你是不是嫌弃我)*/
@property (nonatomic, copy) NSString * text;
/**文本颜色 - 默认黑色*/
@property (nonatomic, strong) UIColor * textColor;
/**文本字体 - 默认系统粗24*/
@property (nonatomic, strong) UIFont * font;
/**边框颜色 - 默认红色*/
@property (nonatomic, strong) UIColor * borderColor;
/**边框宽度 - 默认2*/
@property (nonatomic, assign) CGFloat borderWidth;
/**圆角 - 默认4*/
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                  deleteImage:(UIImage *)dImage;

/**开启使用*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**代理回调*/
- (void)callBack;
/**清除*/
- (void)cleanUp;
@end
