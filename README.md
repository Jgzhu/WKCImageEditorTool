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


