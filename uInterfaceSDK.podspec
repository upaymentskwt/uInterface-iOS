Pod::Spec.new do |s|
  s.name                    = 'uInterfaceSDK'
  s.version                 = '1.0.5'
  s.summary                 = 'This library simplifies the integration of user interface components and payment processing features into iOS applications.'
  s.description             = 'uInterfaceSDK is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects.'
  s.homepage                = 'https://github.com/upaymentskwt/uInterface-iOS'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'upaymentskwt' => 'license@upayments.com' }
  s.source                  = { :git => 'https://github.com/upaymentskwt/uInterface-iOS', :tag => s.version.to_s }
  s.ios.deployment_target   = '12.0'
  # s.source_files            = 'uInterfaceSDK/**/*.{h,m}'
  s.source_files            = 'SDK/v2/uPaymentGatewayUniversalFramework.xcframework/ios-arm64/uPaymentGateway.framework/Headers/*.{h}'
end