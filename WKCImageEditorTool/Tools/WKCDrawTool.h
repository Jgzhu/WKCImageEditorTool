//
//  WKCDrawTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCDrawTool;

@protocol WKCDrawToolDelegate<NSObject>

- (void)drawTool:(WKCDrawTool *)tool
 didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCDrawTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCDrawToolDelegate> delegate;

/**画笔宽度 - 默认8*/
@property ( nonatomic, assign ) CGFloat lineWidth;
/**画笔颜色 - 默认红色*/
@property ( nonatomic, strong ) UIColor * lineColor;

/**橡皮擦*/
- (void)eraser;
/**清除*/
- (void)cleanUp;
/**开启使用*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**代理回调*/
- (void)callBackEdited;
@end
