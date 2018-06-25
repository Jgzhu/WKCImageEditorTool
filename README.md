# WKCImageEditorTool

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCImageEditorTool.svg?style=flat)](https://cocoapods.org/pods/WKCImageEditorTool) [![License: MIT](https://img.shields.io/cocoapods/l/WKCImageEditorTool.svg?style=flat)](http://opensource.org/licenses/MIT)

图片编辑,滤镜、亮度调节、旋转、画笔、贴图、马赛克、文本、裁剪.

` pod 'WKCImageEditorTool' `

` #import <WKCImageEditorTool/WKCImageEditorTool.h> `

主体 WKCImageEditorTool 有三个代理回调.
1.  回调编辑中的图片 - 展示效果用(滤镜、旋转、亮度模式有效).
```
- (void)imageEditorTool:(WKCImageEditorTool *)tool
editingImage:(UIImage *)editing;
```
2.  回调编辑确认的图片
```
- (void)imageEditorTool:(WKCImageEditorTool *)tool
editedImage:(UIImage *)edited;
```
3. 彻底取消,回调原始图
```
- (void)imageEditorTool:(WKCImageEditorTool *)tool
cancelImage:(UIImage *)cancel;
```

具体的各个工具属性设置,去设置各个tool属性.(最后的位置附各工具属性和方法列表).
```
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
```
## 滤镜
1. 源图与滤镜后的图都会在子线程强制解析,解析后缓存,再在主线程回调.再次加载会加载缓存图片.
2. 使用如下:
```
- (WKCImageEditorTool *)editorTool {
if (!_editorTool) {
_editorTool = [[WKCImageEditorTool alloc] initWithFrame:self.imageView.bounds sourceImage:self.imageView.image];
_editorTool.editorType = WKCImageEditorToolTypeFilter;
_editorTool.delegate = self;
}
return _editorTool;
}

```
添加到父视图(需要展示的图片imageView上).
```
[self.imageView addSubview:self.editorTool];
```
设置类型为滤镜,在触发事件内,设置类型,开启使用即可
```
self.editorTool.filterTool.filterType = WKCFilterTypeInstant;
[self.editorTool fire];
```
使用完成后,工具会自动关闭.某些模式下需要手动,调用`- (void)confirm;`去回调结果并关闭(例如画笔、图贴等,需要编辑完成再确认操作的).
效果图:

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/怀旧.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/黑白.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/淡黑白.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/灰白.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/单色.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/褪色.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/冲印.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/铭黄.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/复古.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/古画.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/阴影凸.png).


![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/黑白点线条.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/白黑点线条.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/聚光灯.png).

带一些特效的:

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/圆弧.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/色调分离.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/x射线.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/热能.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/万花筒.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/结晶.png).

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/花瓣.png).
等等,其他效果见Demo.

## 旋转

1. 使用(用法都一样).
```
- (WKCImageEditorTool *)editorTool {
if (!_editorTool) {
_editorTool = [[WKCImageEditorTool alloc] initWithFrame:self.imageView.bounds sourceImage:self.imageView.image];
_editorTool.editorType = WKCImageEditorToolTypeRotation;
_editorTool.delegate = self;
}
return _editorTool;
}
```
2. 事件触发.
```
[self.editorTool fire];
self.editorTool.rotationTool.rotationType = WKCImageRotationTypeOrientationLeft;
```
3. 效果图

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/旋转.gif).

## 画笔
1. 使用
```
- (WKCImageEditorTool *)editorTool {
if (!_editorTool) {
_editorTool = [[WKCImageEditorTool alloc] initWithFrame:self.imageView.bounds sourceImage:self.imageView.image];
_editorTool.editorType = WKCImageEditorToolTypeDraw;
_editorTool.delegate = self;
}
return _editorTool;
}
```
2. 开启
 `[self.editorTool fire]; `
3. 确认 
` [self.editorTool confirm]; `
4. 效果图

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/画笔.gif).

## 贴图
贴图与上边有些区别.贴图初始时需要设置贴图和删除键.其有另外的初始方法.(但仍包含上述方法的初始,各初始化是递进关系，并不是单一关系).

1. 初始化
```
- (WKCImageEditorTool *)editorTool {
if (!_editorTool) {
_editorTool = [[WKCImageEditorTool alloc] initWithFrame:self.imageView.bounds sourceImage:self.imageView.image stickerImage:[UIImage imageNamed:@"toolBar_stickes_1"] deleteImage:[UIImage imageNamed:@"toolBar_stickes_delete"]];
_editorTool.editorType = WKCImageEditorToolTypeSticker;
_editorTool.delegate = self;
}
return _editorTool;
}
```
2. 橡皮擦
调用 ` [self.editorTool.drawTool eraser]; ` 开启橡皮擦模式.
其他方法相同,之后不重复写了.

3. 效果图

![Alt text](https://github.com/WeiKunChao/WKCImageEditorTool/raw/master/screenShort/贴图.gif).




