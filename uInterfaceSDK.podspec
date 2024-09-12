Pod::Spec.new do |spec|

  spec.name                     = "uInterfaceSDK"
  spec.version                  = "1.0.9"
  spec.summary                  = "This library simplifies the integration of user interface components and payment processing features into iOS applications."
  
  spec.description = <<-DESC
  uInterfaceSDK is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects.

  DESC

  spec.homepage                 = "https://github.com/upaymentskwt/uInterface-iOS"
  spec.license                  = { :type => "MIT", :file => "LICENSE" }

  spec.author                   = { "upaymentskwt" => "license@upayments.com" }
  
  spec.source                   = { :git => "https://github.com/upaymentskwt/uInterface-iOS.git", :tag => spec.version.to_s }
  spec.ios.deployment_target    = "12.0"

  spec.source_files             = "SDK_Framework/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.{h}"
  spec.requires_arc             = true
  # spec.vendored_frameworks      = "SDK_Framework/uInterfaceSDK.xcframework"
  spec.vendored_frameworks      = "SDK_Framework/uInterfaceSDK.xcframework"
  spec.pod_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig     = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.frameworks               = "UIKit"
end

