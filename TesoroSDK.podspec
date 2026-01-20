Pod::Spec.new do |s|
  s.name             = 'TesoroSDK'
  s.version          = '0.0.8-alpha'
  s.summary          = 'Tesoro SDK for iOS - Integrate the Tesoro Value Wall into your iOS apps'
  s.description      = <<-DESC
    The official Tesoro SDK for iOS enables you to integrate the Tesoro Value Wall
    into your iOS applications with just a few lines of code.
  DESC
  s.homepage         = 'https://github.com/tesoroxpinc/tesoroxp-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tesoro' => 'support@tesoroxp.com' }
  s.source           = { :git => 'https://github.com/tesoroxpinc/tesoroxp-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/TesoroSDK/**/*.swift'
  s.frameworks = 'WebKit', 'UIKit'
end
