# uInterfaceSDK - PaymentSDK Integration Guide

Welcome to the `uInterfaceSDK` Library! This document provides detailed instructions on how to integrate and use this SDK in your project. This guide will walk you through the steps to integrate and use the `uInterfaceSDK` in your project, with clear examples, installation instructions, and troubleshooting tips to ensure a smooth experience for both new and experienced developers.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#using-cocoapods)
  - [Swift Package Manager](#using-swift-package-manager)
  - [Manual Installation](#using-manual-installation)
- [Integration Steps](#integration-steps)
  - [Initial Setup](#initial-setup)
  - [Configuring the SDK](#configuring-the-sdk)
- [Usage](#usage)
- [Example](#example)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
  
## Introduction

`uInterfaceSDK` is a versatile SDK designed to simplify the integration of user interface components and payment processing features into your iOS applications. It includes a comprehensive PaymentSDK module that facilitates seamless payment processing across multiple projects. This guide will walk you through the steps to integrate and use the SDK in your project.

## Features
- Modular and Flexible Architecture
- Seamless Integration with iOS Projects
- Robust Payment Processing Features via SDK

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

2. To use the latest features, use external source dependencies:

```ruby
pod 'uInterfaceSDK', :git => 'Put our git URL here'
```

3. Install `uInterfaceSDK`:

```ruby
pod install
```

4. Open the generated `.xcworkspace` file and start using the SDK.

### Using Swift Package Manager

1. Open your project in Xcode.
2. Go to `File > Add Package Dependencies.`
3. Enter the package repository URL: `Put our git URL here`
4. Choose the appropriate version.
5. Complete the integration by following the prompts.


### Using Manual Installation
1. Download the latest release from the [Releases page](https://github.com/your-repo/uInterfaceSDK/releases).
2. Drag and drop the `uInterfaceSDK.xcodeproj` file into your Xcode project.
3. Add `uInterfaceSDK.framework` under `Link Binery With Libraries` in your project settings.

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

1. **Create a Payment Request:** You'll need to create an instance of `PaymentDetail` to describe the payment.

```swift
// Construct product details for the payment
let product = ProductModel(
    name: "T-Shirt", // The name of the product
    description: "T-Shirt is ekdam must", // A brief description of the product
    price: 500, // The price per unit of the product
    quantity: 2 // The quantity of the product being purchased
)

// Construct customer details for the payment
let customer = CustomerModel(
    uniqueID: "2129879kjbljg767881", // The unique identifier for the customer
    name: "Dharmendra Kakde", // The customer's name
    email: "kakde.dharmendra@upayments.com", // The customer's email address
    mobile: "+96566336537" // The customer's mobile number
)

// Construct order details for the payment
let order = OrderModel(
    orderId: "202210101255255144669", // The unique order ID for tracking the order
    reference: "11111991", // A reference identifier for the order
    description: "Purchase order received for Logitech K380 Keyboard", // A brief description of the order
    currency: "KWD", // The currency in which the payment is made
    amount: 20 // The total amount to be paid for the order
)

// Construct paymentGateway details for the payment
let paymentGateway = PaymentGatewayModel(src: "knet")

// Construct reference details for the payment
let reference = ReferenceModel(referenceId: "202210101202210101")

// Construct the payment request details model
let paymentRequestDetails = PaymentRequestModel(
    products: [product], // The list of products included in the payment
    order: order, // The order details for the payment
    paymentGateway: paymentGateway, // The paymentGateway details for payment
    language: "en", // The language details for payment
    reference: reference, // The reference details for payment
    customer: customer, // The customer details for the payment
    customerExtraData: "User define data", // Customer more details for payment
    returnURL: "https://example.com/success", // URL to redirect to upon a successful payment
    cancelURL: "https://example.com/cancel", // URL to redirect to if the payment is canceled
    notificationURL: "https://webhook.site/2547b895-5899-4a21-a6f2-ed34c4228216" // Notification URL details for payment
)
```

2. **Create a APIManager Request:** You'll need to create an instance of `APIManager` class to call the API's.

```swift
// Create an instance of the PaymentAPIManager
let objPaymentManager = PaymentAPIManager()
```

3. **Start the Payment:** Using the instance of `APIManager` class, you can initiate and call the API for a payment session.

```swift
// Initiating the payment request
self.objPaymentManager.createPayment(isBackground: false, token: headerToken, paymentRequestDetails: paymentRequestDetails, controller: self) { result in
    switch result {
    case .success(let paymentResult):
        // Handle a successful payment by printing the result message
        print("Payment successful: \(paymentResult.message)")
    case .failure(let error):
        // Handle a failed payment by printing the error reason
        print("Payment failed: \(error.reason ?? "")")
    }
}
```

4. **Handling Results:** The result of the payment will be passed back in a completion handler with either a success or failure case.

## Example

For a complete example, check out our sample projects:
- [iOS Sample Project](https://github.com/YourRepo/ios-sample)

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
