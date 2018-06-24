//
//  WKCTextTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/23.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCTextTool.h"
#import "UIView+Frame.h"
#import "WKCCaptureTool.h"
@interface WKCTextItem:UIView

@property (nonatomic, strong) UIView * layerView;
@property (nonatomic, strong) UITextField * textField;

/**活跃状态*/
- (void)setNoActivity;

@end

@implementation WKCTextItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isCanPan = YES;
        [self addSubview:self.layerView];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)setNoActivity {
    [self endEditing:YES];
    self.layerView.layer.borderWidth = 0;
    self.layerView.layer.borderColor = nil;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont boldSystemFontOfSize:24];
        _textField.text = @"你是不是嫌弃我";
        _textField.textAlignment = NSTextAlignmentCenter;
    }
    return _textField;
}

- (UIView *)layerView {
    if (!_layerView) {
        _layerView = [[UIView alloc] initWithFrame:self.bounds];
        _layerView.userInteractionEnabled = YES;
        _layerView.layer.borderColor = [UIColor redColor].CGColor;
        _layerView.layer.borderWidth = 2;
        _layerView.layer.cornerRadius = 4;
    }
    return _layerView;
}

@end

@interface WKCTextTool() {
    UIImage *_delete;
    CGFloat _deleteWidth;
    CGFloat _deleteHeight;
}

@property (nonatomic, strong) WKCTextItem * textItem;
@property (nonatomic, strong) UIButton * deleteButton;

@end

@implementation WKCTextTool

#pragma mark ---<OutsideMethod>---

- (instancetype)initWithFrame:(CGRect)frame
                  deleteImage:(UIImage *)dImage {
    if (self = [super initWithFrame:frame]) {
        
        _delete = dImage;
        _deleteWidth = dImage.size.width ;
        _deleteHeight = dImage.size.height ;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.textItem];

        self.hidden = YES;
    }
    return self;
}

- (void)fireOn {
    [self setActivity:YES];
}

- (void)fireOff {
    [self setActivity:NO];
}

- (void)cleanUp {
    self.hidden = YES;
}

- (void)callBack {
    UIImage *finalImage = [WKCCaptureTool captureView:self.superview.superview isSave:NO completionHandle:^(BOOL isSuccess, NSError *error) {
        self.hidden = YES;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textTool:didFinishEditImage:)]) {
        [self.delegate textTool:self didFinishEditImage:finalImage];
    }
}

#pragma mark ---<PrivateMethod>---

- (void)setActivity:(BOOL)activity {
    if (!activity) {
        [self.textItem setNoActivity];
        self.deleteButton.hidden = YES;
    }else {
        self.hidden = NO;
        self.deleteButton.hidden = NO;
        if (!self.borderWidth) self.borderWidth = 2;
        if (!self.borderColor) self.borderColor = [UIColor redColor];
        self.textItem.layerView.layer.borderWidth = self.borderWidth;
        self.textItem.layerView.layer.borderColor = self.borderColor.CGColor;
    }
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (void)actionDelete {
    self.hidden = YES;
}

#pragma mark ---<Setter>---

- (void)setText:(NSString *)text {
    _text = text;
    self.textItem.textField.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textItem.textField.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textItem.textField.font = font;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.textItem.layerView.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.textItem.layerView.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.textItem.layerView.layer.cornerRadius = cornerRadius;
}

#pragma mark ---<Lazy init>---

- (WKCTextItem *)textItem {
    if (!_textItem) {
        _textItem = [[WKCTextItem alloc] initWithFrame:CGRectMake(0, 0, 250, 60)];
        _textItem.center = self.center;
        [_textItem addSubview:self.deleteButton];

    }
    return _textItem;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:_delete forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:_delete forState:UIControlStateSelected];
        [_deleteButton setBackgroundImage:_delete forState:UIControlStateHighlighted];
        _deleteButton.frame = CGRectMake(0, 0, _deleteWidth, _deleteHeight);
        _deleteButton.center = CGPointMake(0, 0);
        [_deleteButton addTarget:self action:@selector(actionDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
