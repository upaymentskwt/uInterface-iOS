Pod::Spec.new do |s|
  s.name                    = 'uInterfaceSDK'
  s.version                 = '1.0.7'
  s.summary                 = 'This library simplifies the integration of user interface components and payment processing features into iOS applications.'
  s.description             = <<-DESC
                              uInterfaceSDK is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects.
                              DESC
  s.homepage                = 'https://github.com/upaymentskwt/uInterface-iOS'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'upaymentskwt' => 'license@upayments.com' }
  s.source                  = { :git => 'https://github.com/upaymentskwt/uInterface-iOS.git', :tag => s.version.to_s }

  # Specify the deployment target
  s.ios.deployment_target    = '12.0'
  s.requires_arc             = true

  # Vendored framework, include all platforms if available in xcframework
  # s.vendored_frameworks      = 'SDK/v2/uInterfaceSDK.xcframework'

  # Public header files from the framework (use .h if any public headers exist)
  # s.public_header_files      = 'SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/Headers/*.h'

  # System frameworks the SDK depends on
  s.frameworks               = 'UIKit', 'Foundation'

  # Optional: Specify excluded architectures if you're targeting specific devices
  s.pod_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig     = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # If you have resource bundles in your framework, include them
  # Uncomment and adjust if applicable
  # s.resource_bundles         = {
  #   'uInterfaceSDK' => ['SDK/v2/uInterfaceSDK.xcframework/ios-arm64/uInterfaceSDK.framework/SDKResources.bundle/*.{html,png}']
  # }

  # Optional: Specify Swift version compatibility (if the SDK includes Swift)
  # Uncomment and adjust if applicable
  # s.swift_versions           = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']
end
