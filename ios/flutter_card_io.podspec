#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_card_io'
  s.version          = '0.0.1'
  s.summary          = 'CardIO flutter plugin.'
  s.description      = <<-DESC
CardIO flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/procedurallygenerated/flutter_card_io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'hello@world.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CardIO'
  s.ios.deployment_target = '8.0'
  s.ios.xcconfig = {
    "LIBRARY_SEARCH_PATHS" => "$(inherited) \"${PODS_ROOT}/CardIO/CardIO\"",
    "OTHER_LDFLAGS" => "$(inherited) -l\"CardIO\" -l\"c++\" -l\"opencv_core\" -l\"opencv_imgproc\" -framework \"AVFoundation\" -framework \"Accelerate\" -framework \"AudioToolbox\" -framework \"CoreMedia\" -framework \"CoreVideo\" -framework \"MobileCoreServices\" -framework \"OpenGLES\" -framework \"QuartzCore\" -framework \"Security\" -framework \"UIKit\""
  }
end

