Pod::Spec.new do |spec|
  spec.name         = 'BGNetwork'
  spec.version      = '0.1.0'
  spec.license      = 'MIT'
  spec.summary      = 'BGNetwork is a request util based on AFNetworking'
  spec.homepage     = 'https://github.com/chunguiLiu/BGNetwork'
  spec.author       = 'chunguiLiu'
  spec.source       = { :git => 'https://github.com/chunguiLiu/BGNetwork.git', :tag => 'v0.1.0' }
  spec.source_files = 'BGNetwork/*'
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.dependency 'AFNetworking', '~> 2.0'
end