#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_bdmap.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_bdmap'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'BaiduMapKit'
  s.dependency 'BMKLocationKit'
  s.dependency 'Kingfisher', '~> 5.0'
  s.platform = :ios, '10.0'
  s.static_framework = true

  
 
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
# s.pod_target_xcconfig = {"ENABLE_BITCODE" => "NO", "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES"}
  s.swift_version = '5.0'
  
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
  
 
  # s.frameworks = ["CoreGraphics", "CoreLocation","OpenGLES","QuartzCore","Security","SystemConfiguration"]
  # s.libraries = ["z", "sqlite3.0", "c++"]
   
  
end
