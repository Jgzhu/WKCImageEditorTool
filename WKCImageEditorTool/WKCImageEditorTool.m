//
//  WKCImageEditorTool.m
//  WKCImageEditorTool
//
//  Created by 魏昆超 on 2018/6/24.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "WKCImageEditorTool.h"

@interface WKCImageEditorTool()<WKCFilterToolDelegate,WKCRotationToolDelegate,WKCDrawToolDelegate,WKCStickersToolDelegate,WKCMosaicToolDelegate,WKCTextToolDelegate,WKCBrightToolDelegate,WKCClipToolDelegate> {
    UIImage *_tmpImage;
    BOOL _isEdited;
    
    UIImage *_stickerImage;
    UIImage *_stickerDelete;
    UIImage *_textDelete;
}

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
            [self.filterTool callBack];
        }
            break;
        case WKCImageEditorToolTypeRotation:
        {
            [self.rotationTool callBack];
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
            [self.mosaicTool refreshOrigin:_tmpImage];
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
            [self.brightTool refreshOrigin:_tmpImage];
            [self.brightTool callBack];
        }
            break;
        case WKCImageEditorToolTypeClip:
        {
            [self.clipTool fireOn];
            [self.clipTool refreshOrigin:_tmpImage];
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
            [self.filterTool callBack];
        }
            break;
        case WKCImageEditorToolTypeRotation:
        {
            [self.rotationTool callBack];
        }
            break;
        case WKCImageEditorToolTypeDraw:
        {
            [self.drawTool callBack];
            [self.drawTool fireOff];
        }
            break;
        case WKCImageEditorToolTypeSticker:
        {
            [self.stickerTool fireOff];
            [self.stickerTool callBack];
        }
            break;
        case WKCImageEditorToolTypeMosaic:
        {
            [self.mosaicTool callBack];
            [self.mosaicTool fireOff];
        }
            break;
        case WKCImageEditorToolTypeText:
        {
            [self.textTool fireOff];
            [self.textTool callBack];
        }
            break;
        case WKCImageEditorToolTypeBright:
        {
            [self.brightTool callBack];
            [self.brightTool fireOff];
        }
            break;
        case WKCImageEditorToolTypeClip:
        {
            [self.clipTool callBack];
            [self.clipTool fireOff];
        }
            break;
        default:
            break;
    }
    self.hidden = YES;
    [self refreshTools];
}

- (void)cancel {
    self.hidden = YES;
    [self refreshTools];
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
    if (_stickerDelete && _stickerImage) [self addSubview:self.stickerTool];
    if (_textDelete) [self addSubview:self.textTool];
}

- (void)refreshTools {
    self.filterTool = nil;
    self.rotationTool = nil;
    [self.drawTool fireOff];
    [self.stickerTool fireOff];
    [self.mosaicTool fireOff];
    [self.textTool cleanUp];
    [self.brightTool fireOff];
    [self.clipTool fireOff];
}

- (void)didMoveToSuperview {
    self.superview.userInteractionEnabled = YES;
}

- (void)handleWithStateWithFinal:(UIImage *)finalImage {
    _tmpImage = finalImage;
    if (!_isEdited) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorTool:editingImage:)]) {
            [self.delegate imageEditorTool:self editingImage:_tmpImage];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorTool:editedImage:)]) {
            [self.delegate  imageEditorTool:self editedImage:_tmpImage];
        }
        _isEdited = NO;
    }
}

#pragma mark ---<Delegates>---

- (void)filterTool:(WKCFilterTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)rotationTool:(WKCRotationTool *)tool
  didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)drawTool:(WKCDrawTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)stickerTool:(WKCStickersTool *)tool
 didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)mosaicTool:(WKCMosaicTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)textTool:(WKCTextTool *)tool
didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)brightTool:(WKCBrightTool *)tool didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

- (void)clipTool:(WKCClipTool *)tool didFinishEditImage:(UIImage *)finalImage {
    [self handleWithStateWithFinal:finalImage];
}

#pragma mark ---<Setter>---

- (void)setSourceImage:(UIImage *)sourceImage {
    _sourceImage = sourceImage;
    _tmpImage = sourceImage;
}

#pragma mark ---<Lazy init>---

- (WKCFilterTool *)filterTool {
    if (!_filterTool) {
        _filterTool = [[WKCFilterTool alloc] initWithFrame:self.bounds originImage:_tmpImage];
        _filterTool.delegate = self;
    }
    return _filterTool;
}

- (WKCRotationTool *)rotationTool {
    if (!_rotationTool) {
        _rotationTool = [[WKCRotationTool alloc] initWithFrame:self.bounds originImage:_tmpImage];
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
        _mosaicTool = [[WKCMosaicTool alloc] initWithFrame:self.bounds image:_tmpImage];
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
        _brightTool = [[WKCBrightTool alloc] initWithFrame:self.bounds originImage:_tmpImage];
         _brightTool.delegate = self;
    }
    return _brightTool;
}

- (WKCClipTool *)clipTool {
    if (!_clipTool) {
        _clipTool = [[WKCClipTool alloc] initWithFrame:self.bounds originImage:_tmpImage];
        _clipTool.delegate = self;
    }
    return _clipTool;
}
@end
