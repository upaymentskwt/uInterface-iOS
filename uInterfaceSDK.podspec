Pod::Spec.new do |s|
  s.name                    = 'uInterfaceSDK'
  s.version                 = '1.0.7'
  s.summary                 = 'This library simplifies the integration of user interface components and payment processing features into iOS applications.'
  s.description             = 'uInterfaceSDK is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects.'
  s.homepage                = 'https://github.com/upaymentskwt/uInterface-iOS'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'upaymentskwt' => 'license@upayments.com' }
  s.source                  = { :git => 'https://github.com/upaymentskwt/uInterface-iOS.git', :tag => s.version.to_s }
  # s.source_files            = 'SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.h'
  
  s.source_files = 'SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.{h}'
  s.resource_bundles = {
     'uInterfaceSDK' => ['SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/SDKResources.bundle/*.{html,png}']
   }
  
   s.ios.deployment_target   = '12.0'
   s.requires_arc = true
   
  # s.vendored_frameworks     = 'SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework'
  # s.public_header_files = 'SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.h'
  # s.frameworks              = 'UIKit', 'Foundation'
  # s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  # s.vendored_frameworks = 'SDK/v2/uInterfaceSDK.xcframework'
  
  # Include any resources like images or bundled assets if applicable
  # s.resources = 'uInterface.xcframework/**/*.bundle'

  # If the framework depends on any system libraries or other CocoaPods, specify them
  s.frameworks = 'UIKit', 'Foundation'

  # For Swift versions (if applicable)
  # s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']  # Adjust based on Swift compatibility
  
    s.ios.vendored_frameworks = 'SDK/v2/uInterfaceSDK.xcframework'
    s.vendored_frameworks = 'SDK/v2/uInterfaceSDK.xcframework'
  
end
