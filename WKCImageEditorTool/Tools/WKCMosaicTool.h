//
//  WKCMosaicTool.h
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCMosaicTool;

@protocol WKCMosaicToolDelegate<NSObject>

- (void)mosaicTool:(WKCMosaicTool *)tool
didFinishEditImage:(UIImage *)finalImage;

@end

@interface WKCMosaicTool : UIView

/**代理*/
@property (nonatomic, weak) id<WKCMosaicToolDelegate> delegate;
/**马赛克宽度*/
@property (nonatomic,assign) CGFloat mosaicWidth;

/**
 *初始化
 */
-(instancetype)initWithFrame:(CGRect)frame
                       image:(UIImage *)image;

/**刷新源图*/
- (void)refreshOrigin:(UIImage *)origin;
/**开启*/
- (void)fireOn;
/**关闭*/
- (void)fireOff;
/**给整张图打马赛克*/
- (void)fullMosaic;
/**代理回调*/
- (void)callBack;
/**清除*/
- (void)cleanUp;

@end
