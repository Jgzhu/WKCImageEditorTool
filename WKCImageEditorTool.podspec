Pod::Spec.new do |s|
s.name         = "WKCImageEditorTool"
s.version      = "0.1.2"
s.summary      = "WKCImageEditorTool is a tool which is can be used for editing image."
s.homepage     = "https://github.com/WeiKunChao/WKCImageEditorTool.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WeiKunChao" => "17736289336@163.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/WeiKunChao/WKCImageEditorTool.git", :tag => "0.1.2" }
s.source_files  = "WKCImageEditorTool/**/*.{h,m}"
s.public_header_files = "WKCImageEditorTool/**/*.h"
s.frameworks = "Foundation", "UIKit"
s.requires_arc = true

end
