version = "1.1.2"

Pod::Spec.new do |spec| 

  spec.name                     = "uInterfaceSDK"
  spec.version                  = version
  spec.summary                  = "This library simplifies the integration of user interface components and payment processing features into iOS applications."
  
  spec.description = <<-DESC
  uInterfaceSDK is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects.

  DESC

  spec.homepage                 = "https://github.com/upaymentskwt/uInterface-iOS"
  spec.license                  = { :type => "MIT", :file => "README.md" }

  spec.author                   = { "upaymentskwt" => "license@upayments.com" }
  
  spec.source                   = { :git => "https://github.com/upaymentskwt/uInterface-iOS.git", :tag => version }
  # spec.source                   = { :git => "https://github.com/upaymentskwt/uInterface-iOS.git", :branch => "main" }
  spec.ios.deployment_target    = "12.0"

  spec.source_files             = "UInterfaceSDK_Framework/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.{h}"
  # spec.source_files             = "SDK/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.{h}"
  spec.requires_arc             = true
  spec.vendored_frameworks      = "UInterfaceSDK_Framework/uInterfaceSDK.xcframework"
  spec.frameworks               = "UIKit"
end