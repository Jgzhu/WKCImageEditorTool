//
//  UIView+Frame.h
//  bcbcbcb
//
//  Created by 魏昆超 on 2018/6/19.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

/**是否可拖动*/
@property (nonatomic, assign) BOOL isCanPan;

+ (NSString *)cellIdentify;

/**阴影*/
- (void)shadowWithCornerRadius:(CGFloat)radius
                         color:(UIColor *)color
                        offset:(CGSize)offset
                       opacity:(CGFloat)opacity
                          blur:(CGFloat)blur;

/**所属控制器*/
- (UIViewController *)viewController;
@end
