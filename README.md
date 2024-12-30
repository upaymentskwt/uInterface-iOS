# uInterfaceSDK - PaymentSDK Integration Guide

`uInterfaceSDK` is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects. This guide will walk you through the steps to integrate and use the SDK in your project.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#using-cocoapods)
  - [Manual Installtion](#using-manual-installation)
- [Integration Steps](#integration-steps)
  - [Initial Setup](#initial-setup)
  - [Configuring the SDK](#configuring-the-sdk)
- [Usage](#usage)
- [Example](#example)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faqs)
  
## Requirements
- **iOS 13.0+**
- **Xcode 12+**
- **Swift 5.0+**
- **Internet Access** (Required for payment processing)

## Installation

### Using CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries like `uInterfaceSDK` in your projects.

1. Add the following line to your `Podfile`:

```ruby
pod 'uInterfaceSDK'
```

2. Install `uInterfaceSDK`:

```ruby
pod install
```

3. Open the generated `.xcworkspace` file and start using the SDK.

### Using Manual Installation

1. Obtain the Universal Framework
- Download the universal framework file named ```(uInterfaceSDK.xcframework)``` from the ```UInterfaceSDK_Framework``` folder from the Git repository.
- Ensure that the framework includes binaries for both simulator and device architectures (e.g., arm64 and x86_64).
2. Add the Framework to Your Project
- Open your Xcode project.
- Drag and drop the uInterfaceSDK.framework file into your project’s file hierarchy in Xcode. 
    - Place it in a dedicated folder (e.g., Frameworks).
- In the dialog that appears:
    - Check "Copy items if needed" to copy the framework to your project directory.
    - Ensure the framework is added to the correct target(s).
3. Configure Build Settings
- Add the Framework to "Frameworks, Libraries, and Embedded Content"
    - Select your project in the Xcode Project Navigator.
    - Navigate to the General tab of your target.
    - Under Frameworks, Libraries, and Embedded Content, click the + button.
    - Select uInterfaceSDK.framework from the list and add it.
- Set the Framework Search Path (if required)
    - Go to the Build Settings tab of your target.
    - Search for Framework Search Paths.
    - Add the path where the framework resides (e.g., $(PROJECT_DIR)/Frameworks).
4. Import and Use the Framework
- In your project’s code files, import the framework:
```ruby
import uInterfaceSDK
```
- Use the classes and methods provided by the framework as described in its documentation.

## Integration Steps

### Initial Setup

Import the SDK into your project files where needed:

```swift
import uInterfaceSDK
```

### Configuring the SDK

Initialize `PaymentAPIManager`: In your `AppDelegate` or wherever your app configuration takes place.

```swift
let objPaymentManager = PaymentAPIManager()
```
   
Set the Base URL for the environment:
During the application launch, set the base URL for the default environment. This step is essential for the SDK to interact with the correct backend environment.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.objPaymentManager.setBaseURL(environment: .production)
    return true
}
```

## Usage

### Payment Processing Flow

Here is a basic flow of how to use the `uInterfaceSDK` within your application.

* **Product Details:** This section involves creating and configuring the product details for the payment.

```swift
// Create a ProductModel instance for the payment
let productDetail = ProductModel(
    name: "Logitech K380",
    description: "Logitech K380 / Easy-Switch for Upto 3 Devices, Slim Bluetooth Tablet Keyboard",
    price: 1,  // Price of the product in the specified currency
    quantity: 1  // Quantity of the product
)

// Add product details to the products array
var products = [ProductModel]()
products.append(productDetail)
```

* **Order Details:** This section handles the creation of the order details.

```swift
// Create an OrderModel instance with order-specific information
let orderDetail = OrderModel(
    orderId: "202210101255255144669",  // Unique identifier for the order
    reference: "11111991",  // Reference number for the order
    description: "Purchase order received for Logitech K380 Keyboard",
    currency: "KWD",  // Currency code
    amount: 0.100  // Total amount for the order
)
```

* **Payment Gateway Details:** This section is responsible for defining the payment gateway details.

```swift
// Create a PaymentGatewayModel instance specifying the source of the payment gateway
let paymentGatewayDetail = PaymentGatewayModel(src: "knet")
```

* **Token Details:** Here, you set up token-related details for the payment.

```swift
// Create a TokenModel instance with payment and customer tokens
let tokenDetail = TokenModel(
    fastToken: "",  // Fast token for payment
    creditCardToken: "",  // Credit card token for payment
    customerUniqueToken: self.customerUniqueID  // Unique token for the customer
)
```

* **Reference Details:** This section involves setting up reference details for the payment.

```swift
// Create a ReferenceModel instance with a reference ID
let referenceDetail = ReferenceModel(referenceId: "202210101202210101")
```

* **Customer Details:** Define the customer information required for the payment.

```swift
// Create a CustomerModel instance with customer information
let customerDetail = CustomerModel(
    uniqueID: "2129879kjbljg767881",  // Unique ID for the customer
    name: "Jhon Smithe",  // Customer's name
    email: "jhon.smith@upayments.com",  // Customer's email address
    mobile: "+96512345678"  // Customer's mobile number
)
```

* **Browser Details:** Set up details about the browser used.

```swift
// Create a BrowserDetailsModel instance with browser information
let browserDetails = BrowserDetailsModel(
    screenWidth: "1920",  // Screen width of the browser
    screenHeight: "1080",  // Screen height of the browser
    colorDepth: "24",  // Color depth of the browser
    javaEnabled: "true",  // Java enabled status
    language: "en"  // Language of the browser
)
```

* **Device Details:** Provide details about the device used for the payment.

```swift
// Create a DeviceModel instance with browser details
let deviceDetail = DeviceModel(
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0",  // User agent string for the browser
    browserDetails: browserDetails  // Browser details
)
```

* **Payment Request:** Finally, create the `PaymentRequestModel` instance with all the gathered details.

```swift
// Create a PaymentRequestModel instance with all payment details
let paymentRequestDetails = PaymentRequestModel(
    products: products,  // List of products to be purchased
    isTest: true,  // Flag indicating if the request is for testing
    order: orderDetail,  // Order details
    paymentGateway: paymentGatewayDetail,  // Payment gateway details
    notificationType: "all",  // Type of notifications to be sent
    language: "en",  // Language for the payment process - en for English & ar For Arabic
    isSaveCard: false,  // Flag indicating if the card should be saved
    isWhitelabeled: true,  // Flag indicating if the payment is whitelabeled
    tokens: tokenDetail,  // Token details
    reference: referenceDetail,  // Reference details
    customer: customerDetail,  // Customer details
    plugin: pluginDetail,  // Plugin details
    customerExtraData: "test data",  // Additional data related to the customer
    returnURL: "https://upayments.com/en/",  // URL to redirect after payment
    cancelURL: "https://www.error.com",  // URL to redirect if payment is canceled
    notificationURL: "https://webhook.site/ce503866-6bb3-4c58-a2f2-a0fa028f10ea",  // URL to receive payment notifications
    device: deviceDetail  // Device details
)
```

* **Create a APIManager Request:** You'll need to create an instance of `APIManager` class to call the API's.

```swift
// Create an instance of the PaymentAPIManager
let objPaymentManager = PaymentAPIManager()
```

* **Start the Payment:** Using the instance of `APIManager` class, you can initiate and call the API for a payment session.

```swift
// Process the payment request
self.objPaymentAPIManager.processPayment(
    isBackground: true,  // Indicates if the request should be processed in the background
    token: self.apiToken,  // API token for authorization
    paymentRequestDetails: paymentRequestDetails,  // Payment request details
    controller: self,  // View controller to handle UI updates
    completionHandler: { result in
        switch result {
        case .success(let response):
                        
            // Extract the refund order ID from the response for future use
            let responseDict = response.transactionDetails.toDictionary()
            self.orderID = responseDict["refund_order_id"] as? String ?? ""
            
            // Show an alert with the payment response message
            self.displayAlert(status: response.message, responseMessage: response)
        
        case .failure(let error):
            // Show an alert with error status and message
            self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
        }
    }
)
```

* **Handling Results:** The result of the payment will be passed back in a completion handler with either a success or failure case.

* **Note:** 
For more parameters check this document
https://developers.upayments.com/reference/addcharge#request-model

## Example

For a complete example, check out our sample projects:
- [iOS Sample Project](https://github.com/upaymentskwt/uInterface-iOS)

## Troubleshooting

### Common Issues

* **Library Not Installed Properly**
   - Ensure the SDK is installed using the correct package manager and linked properly.

* **Build Errors**
   - Check that the correct frameworks are added to "Link Binary with Libraries" in your Build Phases.

* **API Keys Not Recognized**
   - Double-check the API keys in your configuration.

### FAQs

* **Q: What should I do if my payment SDK fails to initialize?**
  - Check your API keys, verify internet connectivity, and ensure the SDK's initialization method is being called at the correct point in the app lifecycle. Refer to the SDK documentation for the required parameters and environment configurations.

* **Q: Is this SDK compatible with Objective-C?**
  - Currently, the SDK is designed for Swift. Compatibility with Objective-C is not supported.