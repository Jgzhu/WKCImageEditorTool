//
//  WKCImageEditorTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/24.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCImageEditorTool.h"
#import "WKCCaptureTool.h"

@interface WKCImageEditorTool()<WKCFilterToolDelegate,WKCRotationToolDelegate,WKCDrawToolDelegate,WKCStickersToolDelegate,WKCMosaicToolDelegate,WKCTextToolDelegate,WKCBrightToolDelegate,WKCClipToolDelegate> {

    UIImage *_stickerImage;
    UIImage *_stickerDelete;
    UIImage *_textDelete;
}

@property (nonatomic, strong) UIImage * tmpEditing;
@property (nonatomic, strong) UIImage * tmpEdited;
@property (nonatomic, assign) BOOL  isEdited;
@end

@implementation WKCImageEditorTool

#pragma mark ---<OutsideMethod>---

- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source {
    if (self = [super initWithFrame:frame]) {
        self.sourceImage = source;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage {
    if (self = [super initWithFrame:frame]) {
        self.sourceImage = source;
        _stickerImage = sticker;
        _stickerDelete = dImage;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                   textDelete:(UIImage *)tImage {
    if (self = [super initWithFrame:frame]) {
        self.sourceImage = source;
        _textDelete = tImage;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                  sourceImage:(UIImage *)source
                 stickerImage:(UIImage *)sticker
                  deleteImage:(UIImage *)dImage
                   textDelete:(UIImage *)tImage {
    if (self = [super initWithFrame:frame]) {
        self.sourceImage = source;
        _stickerImage = sticker;
        _stickerDelete = dImage;
        _textDelete = tImage;
        [self commonInit];
    }
    return self;
}

- (void)fire {
    self.hidden = NO;
    _isEdited = NO;
    [self refreshTools];
    switch (self.editorType) {
        case WKCImageEditorToolTypeFilter:
        {
            [self.filterTool fireOn];
        }
            break;
        case WKCImageEditorToolTypeRotation:
        {
            [self.rotationTool fireOn];
            [self.rotationTool callBackEditing];
        }
            break;
        case WKCImageEditorToolTypeDraw:
        {
            [self.drawTool fireOn];
        }
            break;
        case WKCImageEditorToolTypeSticker:
        {
            [self.stickerTool fireOn];
        }
            break;
        case WKCImageEditorToolTypeMosaic:
        {
            [self.mosaicTool fireOn];
        }
            break;
        case WKCImageEditorToolTypeText:
        {
            [self.textTool fireOn];
        }
            break;
        case WKCImageEditorToolTypeBright:
        {
            [self.brightTool fireOn];
            [self.brightTool callBackEditing];
        }
            break;
        case WKCImageEditorToolTypeClip:
        {
            [self.clipTool fireOn];
        }
            break;
        default:
            break;
    }
}

- (void)confirm {
     _isEdited = YES;
    switch (self.editorType) {
        case WKCImageEditorToolTypeFilter:
        {
            [self.filterTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeRotation:
        {
            [self.rotationTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeDraw:
        {
            [self.drawTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeSticker:
        {
            [self.stickerTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeMosaic:
        {
            [self.mosaicTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeText:
        {
            [self.textTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeBright:
        {
            [self.brightTool callBackEdited];
        }
            break;
        case WKCImageEditorToolTypeClip:
        {
            [self.clipTool callBackEdited];
        }
            break;
        default:
            break;
    }
    self.hidden = YES;
    [self refreshTools];
    [self refreshToolsOriginImage];
}

- (void)cancel {
    self.hidden = YES;
    [self refreshTools];
    [self postCancel];
}

+ (void)saveImage:(UIImage *)image
 completionHandle:(void (^)(BOOL, NSError *))handle {
    return [WKCCaptureTool
            saveImage:image
            completionHandle:handle];
}

+ (void)captureView:(UIView *)view
                  isSave:(BOOL)save
        completionHandle:(void (^)(UIImage *image,BOOL isSuccess, NSError *error))handle {
    return [WKCCaptureTool
            captureView:view
            isSave:save
            completionHandle:handle];
}

+ (void)captureRect:(CGRect)rect
               fullImage:(UIImage *)full
                  isSave:(BOOL)save
        completionHandle:(void (^)(UIImage *image,BOOL isSuccess, NSError *error))handle  {
    return [WKCCaptureTool
            captureRect:rect
            fullImage:full
            isSave:save
            completionHandle:handle];
}

#pragma mark ---<PrivateMethod>---

- (void)commonInit {
    self.editorType = WKCImageEditorToolTypeFilter;
    [self setUpViews];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.hidden = YES;
}

- (void)setUpViews {
    [self addSubview:self.rotationTool];
    [self addSubview:self.filterTool];
    [self addSubview:self.drawTool];
    [self addSubview:self.mosaicTool];
    [self addSubview:self.brightTool];
    [self addSubview:self.clipTool];
    [self addSubview:self.stickerTool];
    [self addSubview:self.textTool];
}

- (void)refreshTools {
    [self.filterTool fireOff];
    [self.rotationTool fireOff];
    [self.drawTool fireOff];
    [self.stickerTool fireOff];
    [self.mosaicTool fireOff];
    [self.textTool fireOff];
    [self.brightTool fireOff];
    [self.clipTool fireOff];
}

- (void)refreshToolsOriginImage {
    [self.filterTool refreshOrigin:_tmpEdited];
    [self.rotationTool refreshOrigin:_tmpEdited];
    [self.mosaicTool refreshOrigin:_tmpEdited];
    [self.clipTool refreshOrigin:_tmpEdited];
    [self.brightTool refreshOrigin:_tmpEdited];
    _tmpEditing = _tmpEdited;
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (void)postCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorTool:cancelImage:)]) {
        [self.delegate imageEditorTool:self cancelImage:self.sourceImage];
    }
}

- (void)postEditing {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorTool:editingImage:)]) {
        [self.delegate imageEditorTool:self editingImage:_tmpEditing];
    }
}

- (void)postEdited {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorTool:editedImage:)]) {
        [self.delegate  imageEditorTool:self editedImage:_tmpEdited];
    }
}

#pragma mark ---<Delegates>---

- (void)filterTool:(WKCFilterTool *)tool editingImage:(UIImage *)editing {
    _tmpEditing = editing;
    [self postEditing];
}

- (void)filterTool:(WKCFilterTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)rotationTool:(WKCRotationTool *)tool editingImage:(UIImage *)editing {
    _tmpEditing = editing;
    [self postEditing];
}

- (void)rotationTool:(WKCRotationTool *)tool
  didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)drawTool:(WKCDrawTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)stickerTool:(WKCStickersTool *)tool
 didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)mosaicTool:(WKCMosaicTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)textTool:(WKCTextTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)brightTool:(WKCBrightTool *)tool editingImage:(UIImage *)editing {
    _tmpEditing = editing;
    [self postEditing];
}

- (void)brightTool:(WKCBrightTool *)tool didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

- (void)clipTool:(WKCClipTool *)tool didFinishEditImage:(UIImage *)finalImage {
    _tmpEdited = finalImage;
    [self postEdited];
}

#pragma mark ---<Setter>---

- (void)setSourceImage:(UIImage *)sourceImage {
    _sourceImage = sourceImage;
    _tmpEdited = sourceImage;
}

#pragma mark ---<Lazy init>---

- (WKCFilterTool *)filterTool {
    if (!_filterTool) {
        _filterTool = [[WKCFilterTool alloc] initWithFrame:self.bounds originImage:_tmpEdited];
        _filterTool.delegate = self;
    }
    return _filterTool;
}

- (WKCRotationTool *)rotationTool {
    if (!_rotationTool) {
        _rotationTool = [[WKCRotationTool alloc] initWithFrame:self.bounds originImage:_tmpEdited];
        _rotationTool.delegate = self;
    }
    return _rotationTool;
}

- (WKCDrawTool *)drawTool {
    if (!_drawTool) {
        _drawTool = [[WKCDrawTool alloc] initWithFrame:self.bounds];
        _drawTool.delegate = self;
    }
    return _drawTool;
}

- (WKCStickersTool *)stickerTool {
    if (!_stickerTool) {
        _stickerTool = [[WKCStickersTool alloc] initWithFrame:self.bounds stickerImage:_stickerImage deleteImage:_stickerDelete];
        _stickerTool.delegate = self;
    }
    return _stickerTool;
}

- (WKCMosaicTool *)mosaicTool {
    if (!_mosaicTool) {
        _mosaicTool = [[WKCMosaicTool alloc] initWithFrame:self.bounds image:_tmpEdited];
        _mosaicTool.delegate = self;
    }
    return _mosaicTool;
}

- (WKCTextTool *)textTool {
    if (!_textTool) {
        _textTool = [[WKCTextTool alloc] initWithFrame:self.bounds deleteImage:_textDelete];
        _textTool.delegate = self;
    }
    return _textTool;
}

- (WKCBrightTool *)brightTool {
    if (!_brightTool) {
        _brightTool = [[WKCBrightTool alloc] initWithFrame:self.bounds originImage:_tmpEdited];
         _brightTool.delegate = self;
    }
    return _brightTool;
}

- (WKCClipTool *)clipTool {
    if (!_clipTool) {
        _clipTool = [[WKCClipTool alloc] initWithFrame:self.bounds originImage:_tmpEdited];
        _clipTool.delegate = self;
    }
    return _clipTool;
}
@end
