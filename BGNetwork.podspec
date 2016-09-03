Pod::Spec.new do |spec|
  spec.name         = 'BGNetwork'
  spec.version      = '0.2.6'
  spec.license      = 'MIT'
  spec.summary      = 'BGNetwork is a request util based on AFNetworking'
  spec.homepage     = 'https://github.com/liuchungui/BGNetwork'
  spec.author       = { "liuchungui": "404468494@qq.com", "blog": "http://www.liuchungui.com"}
  spec.source       = { :git => 'https://github.com/chunguiLiu/BGNetwork.git', :tag => spec.version }
  spec.source_files = "BGNetwork/*"
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.dependency 'AFNetworking', '~> 3.0.2'

  #指定xcode编译配置
  spec.xcconfig = {
   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }
end
