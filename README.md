# uInterfaceSDK for iOS: Merchant Integration Guide

This guide provides complete, external-facing documentation for merchants and developers integrating the **UPayments SDK (`uInterfaceSDK`)** into their iOS applications.

`uInterfaceSDK` is the official, comprehensive payment framework for UPayments. It provides a complete payment gateway experience including automated checkout web redirection, 3D Secure modal handling, native Apple Pay integration, customer card tokenization, auto-deduct recurring billing, invoicing, and refunds.

---

## Table of Contents

1. [Overview](#1-overview)
   - [What `uInterfaceSDK` Provides](#what-uinterfacesdk-provides)
   - [Primary Integration Use Cases](#primary-integration-use-cases)
2. [Requirements & Prerequisites](#2-requirements--prerequisites)
   - [Platform & Tooling Requirements](#platform--tooling-requirements)
   - [Dependencies & Permissions](#dependencies--permissions)
   - [Apple Pay Requirements (Optional)](#apple-pay-requirements-optional)
3. [Installation](#3-installation)
   - [Method A: Swift Package Manager (SPM)](#method-a-swift-package-manager-spm)
   - [Method B: Manual Integration (XCFramework)](#method-b-manual-integration-xcframework)
4. [Configuration & Environments](#4-configuration--environments)
   - [Key Terms (Read This First)](#key-terms-read-this-first)
   - [Supported Environments](#supported-environments)
   - [Sandbox vs Production](#sandbox-vs-production)
   - [Switching from Sandbox to Production](#switching-from-sandbox-to-production)
5. [Initialization](#5-initialization)
   - [Basic SDK Initialization](#basic-sdk-initialization)
   - [Configuring Native Apple Pay (Optional)](#configuring-native-apple-pay-optional)
   - [When is the native Apple Pay sheet shown?](#when-is-the-native-apple-pay-sheet-shown)
6. [Step-by-Step Payment Integration](#6-step-by-step-payment-integration)
   - [Step 1: Construct the Payment Request](#step-1-construct-the-payment-request)
   - [Step 2: Pre-Flight Validation Rules](#step-2-pre-flight-validation-rules)
   - [Step 3: Process the Payment](#step-3-process-the-payment)
   - [Step 4: Inspect the Payment Result](#step-4-inspect-the-payment-result)
7. [Additional Payment Features](#7-additional-payment-features)
   - [Checking Payment Status (Tracking ID)](#checking-payment-status-tracking-id)
   - [Checking Payment Button Status](#checking-payment-button-status)
   - [Saved Cards & Customer Tokenization](#saved-cards--customer-tokenization)
   - [Auto-Deduct (Recurring Billing)](#auto-deduct-recurring-billing)
   - [Invoicing](#invoicing)
   - [Refunds (Single & Multi-Vendor)](#refunds-single--multi-vendor)
8. [API Reference](#8-api-reference)
   - [Core Facade: `UPayments`](#core-facade-upayments)
   - [Payment Request Models](#payment-request-models)
   - [Result Models: `PaymentResult` & `TransactionDetails`](#result-models-paymentresult--transactiondetails)
9. [Error Handling](#9-error-handling)
   - [The `NetworkError` Struct](#the-networkerror-struct)
   - [Cancellation Handling](#cancellation-handling)
   - [Validation Failures](#validation-failures)
10. [Backward Compatibility](#10-backward-compatibility)
11. [Production Checklist](#11-production-checklist)
12. [Troubleshooting & FAQs](#12-troubleshooting--faqs)

---

## 1. Overview

### What `uInterfaceSDK` Provides

`uInterfaceSDK` is an all-in-one payment gateway integration toolkit for iOS apps:

- **Unified Payment Processing**: Seamlessly accepts KNET, Credit/Debit cards (Visa, MasterCard, Amex), and Apple Pay.
- **Automated Web Redirection & 3D Secure**: Manages the payment checkout sheet modally via `WKWebView`, detects terminal bank redirects, and securely returns structured transaction details to your app.
- **Native Apple Pay**: Seamlessly integrated with Apple's `PassKit`. When an Apple Pay transaction is initiated, the SDK presents the native biometric payment sheet and charges the resulting cryptogram automatically.
- **Card Tokenization & Management**: Allows customers to securely link and save cards for one-click checkouts.
- **Auto-Deduct Recurring Payments**: Enables scheduled or subscription-based charges against stored card tokens with zero customer friction.
- **Invoicing & Refunds**: Programmatically generate invoices and process single or multi-vendor refunds directly from your application.

### Primary Integration Use Cases

1. **Standard In-App Checkout**: Customers purchase goods or services, choose their preferred payment method (KNET, Credit Card, or Apple Pay), and complete checkout within your app.
2. **One-Click & Subscription Billing**: Save cards on file and perform automated recurring charges via Auto-Deduct.
3. **Marketplace & Multi-Vendor Operations**: Manage payment routing and multi-vendor refunds across separate merchant accounts.

---

## 2. Requirements & Prerequisites

### Platform & Tooling Requirements

- **iOS Deployment Target**: iOS 13.0 or higher (iOS 15.0+ recommended)
- **Swift Version**: Swift 5.0, 5.3, or 5.5+
- **Xcode Version**: Xcode 14.0 or newer
- **Supported Architectures**: `arm64` (iOS Devices) and `arm64` / `x86_64` (iOS Simulators)

### Dependencies & Permissions

- **Dependencies**: The SDK uses native Apple frameworks (`UIKit`, `WebKit`, `PassKit`, `Foundation`) plus one UPayments companion package, **`uInterfaceNative`**. Swift Package Manager downloads it for you automatically; for manual installs you must add it yourself (see [Method B](#method-b-manual-integration-xcframework)). No other third-party libraries are needed.
- **Network Security**: All communication occurs over HTTPS. Ensure your app's `Info.plist` does not block arbitrary loads if communicating with testing servers, although UPayments production endpoints strictly enforce TLS 1.2+.

### Apple Pay Requirements (Optional)

If your app offers native Apple Pay:

1. An active **Apple Developer Program** account.
2. A **Merchant Identifier** registered in the Apple Developer Member Center (`merchant.com.yourcompany.app`).
3. An **Apple Pay Payment Processing Certificate** generated with the CSR provided in your UPayments Merchant Portal.
4. The **Apple Pay** capability enabled in your Xcode target's **Signing & Capabilities**.

_(If you only offer KNET and Credit Cards through the web redirection flow, no Apple Developer certificates are required)._

---

## 3. Installation

### Method A: Swift Package Manager (SPM)

1. In Xcode, navigate to **File** → **Add Packages...**
2. Enter the repository URL:
   ```text
   https://github.com/upaymentskwt/uInterface-iOS
   ```
3. Set the dependency rule to **Up to Next Major Version** (e.g. `1.0.0`) and select your application target.

If integrating via `Package.swift`:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/upaymentskwt/uInterface-iOS", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: ["uInterfaceSDK"]
        )
    ]
)
```

### Method B: Manual Integration (XCFramework)

1. Obtain `uInterfaceSDK.xcframework` (and `uInterfaceNative.xcframework`).
2. Drag both `.xcframework` bundles into your Xcode project under your target's **General** → **Frameworks, Libraries, and Embedded Content**.
3. Set the embed type to **Embed & Sign**.

---

## 4. Configuration & Environments

### Key Terms (Read This First)

| Term                  | What it means                                                                                                                                                                                                                                  |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **API key**           | Your merchant key from the UPayments portal. Every SDK call uses it.                                                                                                                                                                           |
| **Secret key**        | An HMAC key tied to your API key. You normally don't need it — the SDK fetches it for you.                                                                                                                                                     |
| **`returnURL`**       | The URL the payment page redirects to after a finished payment. The SDK*watches* for this redirect, closes the web view, and gives you the result. It does **not** need to be a real page in your app, but use your own HTTPS domain.          |
| **`cancelURL`**       | Same idea as`returnURL`, but for a cancelled payment.                                                                                                                                                                                          |
| **`notificationURL`** | Your**backend** webhook. UPayments calls it server-to-server with the final payment status. This is the source of truth for order fulfilment.                                                                                                  |
| **Tracking ID**       | A UPayments ID for a transaction (`transactionDetails.trackingID`). Use it to look up status later.                                                                                                                                            |
| **Whitelabel**        | A merchant account setting controlled by UPayments (not by your app). Whitelabel merchants choose the payment method in their own app UI and must send`paymentGateway.src`. Ask UPayments if you're unsure whether your account is whitelabel. |

> [!WARNING]
> **Never hard-code your live API key or secret key in a release build.** Anything inside an app binary can be extracted. Prefer loading the key from your backend or a build configuration that is not committed to source control.

### Supported Environments

`uInterfaceSDK` strictly supports two standard environments:

| Environment       | Base URL                                   | Purpose                                              |
| :---------------- | :----------------------------------------- | :--------------------------------------------------- |
| **`.sandbox`**    | `https://sandboxapi.upayments.com/api/v1/` | Development, sandbox testing, test card transactions |
| **`.production`** | `https://api.upayments.com/api/v1/`        | Live merchant production transactions                |

> [!IMPORTANT]
> UPayments strictly supports standard `.sandbox` and `.production` environments. Custom or development endpoints are not supported for merchant production releases.

### Sandbox vs Production

| Feature                  | Sandbox (`.sandbox`)                                    | Production (`.production`)                  |
| :----------------------- | :------------------------------------------------------ | :------------------------------------------ |
| **API Keys**             | Sandbox API Key (from UPayments Sandbox Portal)         | Live Production API Key                     |
| **Cards & Gateway**      | Test cards (KNET simulator cards, test Visa/MasterCard) | Real customer credit, debit, and KNET cards |
| **Payment Request Flag** | `isTest: true`                                          | `isTest: false` (or omit)                   |
| **Apple Pay**            | Apple Sandbox Tester account + test cards               | Real cards enrolled in Apple Wallet         |

### Switching from Sandbox to Production

To transition your application to production:

1. Replace your sandbox API key with your live production API key.
2. In your initialization code, change `environment: .sandbox` to `environment: .production`.
3. In `PaymentRequestModel`, set `isTest: false` (or omit).
4. Ensure your `returnURL`, `cancelURL`, and `notificationURL` point to your live HTTPS production servers.

---

## 5. Initialization

### Basic SDK Initialization

Configure the SDK during your app's startup sequence (e.g., in `AppDelegate` or `SceneDelegate`):

```swift
import UIKit
import uInterfaceSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // 1. Initialize UPayments SDK with your API Key
        UPayments.configure(
            apiKey: "YOUR_API_KEY",
            environment: .sandbox // Change to .production for live release
        ) { result in
            switch result {
            case .success:
                // The resolved secret key is passed here, but you don't need it. Never log it.
                print("UPayments SDK ready. Credentials resolved.")
            case .failure(let error):
                print("SDK configuration warning: \(error.localizedDescription)")
            }
        }

        return true
    }
}
```

#### Configuration Options

The `UPayments.configure(...)` method accepts the following parameters:

```swift
public static func configure(
    apiKey: String,
    secretKey: String? = nil,
    environment: Environment = .sandbox,
    isWhitelabeled: Bool = false,
    appleIdentifier: AppleIdentifierModel? = nil,
    applePayConfiguration: ApplePayConfiguration? = nil,
    appleMerchantIdentifier: String? = nil,
    completion: ((Result<String, NetworkError>) -> Void)? = nil
)
```

- `apiKey`: _(Required)_ Your UPayments merchant API key.
- `secretKey`: _(Optional)_ Your HMAC secret key. If provided, the SDK skips the remote credentials lookup. If omitted, the SDK fetches and caches it automatically. Most apps should omit it.
- `environment`: `.sandbox` or `.production`. Defaults to `.sandbox`.
- `isWhitelabeled`: _(Optional, usually leave as `false`)_ An initial guess only. Once the SDK loads your account settings from UPayments, the server's whitelabel flag **replaces** this value.
- `appleIdentifier` / `applePayConfiguration` / `appleMerchantIdentifier`: _(Optional)_ Shortcuts to set up native Apple Pay in the same call. Pass **one** of them (if you pass several, `applePayConfiguration` wins, then `appleIdentifier`). Only the merchant identifier and merchant name (`displayName` on `AppleIdentifierModel`) are used. Everything else comes from your account settings. See [Configuring Native Apple Pay](#configuring-native-apple-pay-optional).
- `completion`: Optional closure called with `.success` once credentials are ready, or `.failure(NetworkError)`.

> [!NOTE]
> `configure` stores your API key immediately, so you can call other SDK methods right away. You don't have to wait for `completion`. After a successful configure, the SDK also pre-loads which payment methods your account has enabled (see [Checking Payment Button Status](#checking-payment-button-status)).

You can also dynamically toggle the environment at runtime:

```swift
UPayments.shared.setEnvironment(.production)
```

### Configuring Native Apple Pay (Optional)

If your app accepts Apple Pay natively, register your Apple Pay configuration. You only provide two values:

```swift
let applePayConfig = ApplePayConfiguration(
    merchantIdentifier: "merchant.com.yourcompany.app", // your Apple Pay merchant ID (required)
    merchantName: "Your Store Name"                      // shown on the Apple Pay sheet (optional)
)

UPayments.shared.configureApplePay(applePayConfig)
```

Or pass the same values directly to `configure`:

```swift
UPayments.configure(
    apiKey: "YOUR_API_KEY",
    environment: .sandbox,
    applePayConfiguration: ApplePayConfiguration(
        merchantIdentifier: "merchant.com.yourcompany.app",
        merchantName: "Your Store Name"
    )
)
```

> [!NOTE]
> You **don't** set the country code, supported card networks (Visa, Mastercard, mada, …), merchant capabilities (3DS, credit, debit), or supported countries. The SDK loads these from your UPayments account settings and applies them for you. To change them, contact UPayments; they can't be changed from the app.
>
> It doesn't matter whether you call `configureApplePay` before or after `configure` finishes. The account settings are applied either way.

#### When is the native Apple Pay sheet shown?

The native Apple Pay sheet is shown only when **all** of these are true:

1. Your merchant account is **whitelabel** (set by UPayments).
2. UPayments has allowed **Apple Pay native** (`apple-native`) for your account.
3. **Apple Pay** or **Apple Pay KNET** is enabled in the merchant portal (Upay Merchants App).
4. You configured Apple Pay in the app (see above).

When you send a payment with `paymentGateway.src` set to `"apple-pay"` or `"apple-pay-knet"`, the SDK checks your account settings and decides what to do:

| Your account                                                                                                      | What happens                                                                                          |
| :---------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------- |
| Apple Pay and Apple Pay KNET are both**disabled** in the merchant portal                                          | `processPayment` fails with a `NetworkError` (HTTP 422). Don't show an Apple Pay button in this case. |
| Apple Pay is enabled, but UPayments has**not** allowed Apple Pay native (or the account isn't whitelabel)         | The SDK opens the**hosted Apple Pay page** in a web view.                                             |
| All four conditions above are met                                                                                 | The**native Apple Pay sheet** is shown.                                                               |
| All conditions are met, but the device can't show the sheet (no cards in Wallet, unsupported device or simulator) | The SDK falls back to the**hosted Apple Pay page**.                                                   |

> [!IMPORTANT]
> **Before you show an Apple Pay button, or any other payment button, call `checkPaymentButtonStatus`** (or use `isPaymentAvailable`) and show only the methods that are enabled. See [Checking Payment Button Status](#checking-payment-button-status).

```swift
UPayments.shared.checkPaymentButtonStatus { result in
    guard case .success(let status) = result else { return }
    let data = status.paymentButtonData
    DispatchQueue.main.async { // this callback may arrive on a background thread
        applePayButton.isHidden = !(data?.isApplePayEnabled == true || data?.isApplePayKnetEnabled == true)
        knetButton.isHidden = !status.isKnetEnabled
        cardButton.isHidden = !status.isCreditCardEnabled
    }
}
```

---

## 6. Step-by-Step Payment Integration

### Step 1: Construct the Payment Request

Create a `PaymentRequestModel` with details about the order, customer, products, and return URLs:

```swift
let paymentRequest = PaymentRequestModel(
    products: [
        ProductModel(name: "Wireless Headphones", price: 15.0, quantity: 1.0),
        ProductModel(name: "Shipping", price: 2.5, quantity: 1.0)
    ],
    sessionID: UUID().uuidString,
    isTest: true, // Set to false in production
    order: OrderModel(
        orderId: "ORD_\(Int(Date().timeIntervalSince1970))",
        currency: "KWD",
        amount: 17.50
    ),
    paymentGateway: PaymentGatewayModel(src: "knet"), // "knet", "cc", "apple-pay", or nil
    language: "en", // "en" or "ar"
    reference: ReferenceModel(referenceId: "REF_\(Int(Date().timeIntervalSince1970))"),
    customer: CustomerModel(
        name: "Sara Al-Ahmad",
        email: "sara@example.com",
        mobile: "96512345678"
    ),
    returnURL: "https://yourdomain.com/payment/success",
    cancelURL: "https://yourdomain.com/payment/cancel",
    notificationURL: "https://yourdomain.com/payment/webhook"
)
```

Notes:

- `orderId` and `referenceId` should be unique per payment. Generate them on your backend if possible so you can match the webhook to your order.
- `paymentGateway`: pass `nil` to let the customer choose on the UPayments checkout page. Whitelabel accounts **must** set it (see [Key Terms](#key-terms-read-this-first)).
- Not sure what the three URLs are for? See [Key Terms](#key-terms-read-this-first).

### Step 2: Pre-Flight Validation Rules

To prevent silent failures, `uInterfaceSDK` validates all required fields before initiating network requests.

The following fields are strictly required:

| Field                   | Requirement | Validation Rule                                                                            |
| :---------------------- | :---------- | :----------------------------------------------------------------------------------------- |
| `apiKey`                | Required    | Cannot be empty or whitespace                                                              |
| `order`                 | Required    | Must be present                                                                            |
| `order.amount`          | Required    | Must be strictly greater than zero (`> 0`)                                                 |
| `order.currency`        | Required    | 3-letter currency code (e.g.,`"KWD"`, `"SAR"`, `"AED"`, `"USD"`)                           |
| `language`              | Required    | Preferred language code (e.g.,`"en"`, `"ar"`)                                              |
| `reference.referenceId` | Required    | Non-empty unique reference identifier                                                      |
| `returnURL`             | Required    | Non-empty return URL string                                                                |
| `cancelURL`             | Required    | Non-empty cancel URL string                                                                |
| `notificationURL`       | Required    | Non-empty webhook notification URL string                                                  |
| `paymentGateway.src`    | Conditional | Required if your account is whitelabel (the SDK sets this flag from your account settings) |

> [!CAUTION]
> If any of these fields are missing or invalid, `processPayment` fails fast with `NetworkError.validationFailed(reason:missingFields:)` without displaying a web view or contacting the server.

### Step 3: Process the Payment

Call `UPayments.shared.processPayment` passing the payment request and the presenting view controller:

```swift
UPayments.shared.processPayment(
    request: paymentRequest,
    from: self
) { [weak self] result in
    guard let self = self else { return }

    switch result {
    case .success(let paymentResult):
        self.handlePaymentSuccess(paymentResult)

    case .failure(let error):
        self.handlePaymentFailure(error)
    }
}
```

- `from:` must be a view controller that is currently on screen. The SDK presents its payment screen modally on top of it.
- `isBackground` and `apiKey` are optional extra parameters. Leave `isBackground` at its default (`false`). Pass `apiKey` only if you need to override the key given to `configure`.

The SDK automatically:

1. Validates the request (see Step 2).
2. For Apple Pay, decides between the native sheet and web checkout (see [When is the native Apple Pay sheet shown?](#when-is-the-native-apple-pay-sheet-shown)). If the native sheet is used, the Apple Pay token is charged directly with no web view.
3. Otherwise, calls the UPayments charge API and presents the returned payment page in a modal `WKWebView` (KNET, cards, etc.).
4. Watches for the redirect to your `returnURL` / `cancelURL` and closes the web view automatically.
5. Calls your completion closure on the **main thread**, so you can update UI directly.

### Step 4: Inspect the Payment Result

> [!IMPORTANT]
> **`.success` does not mean the customer paid.** `.success` means the payment flow _finished_. A declined, failed, or cancelled payment also arrives as `.success`. Always check `transactionDetails.result`.
>
> `.failure` means the flow could not run or the server rejected the charge (validation error, network error, missing credentials, etc.).

| `transactionDetails.result` | Meaning                                                       |
| :-------------------------- | :------------------------------------------------------------ |
| `"CAPTURED"` or `"SUCCESS"` | Payment succeeded                                             |
| `"CANCELED"`                | The customer closed the payment screen or the Apple Pay sheet |
| `"DECLINED"`                | The bank declined the payment                                 |
| `"FAILED"`                  | The payment failed for another reason                         |

> [!CAUTION]
> Use the result in the app only to update the UI. Before shipping goods or unlocking content, confirm the payment on your **backend**, using the webhook sent to `notificationURL` or by looking it up with the tracking ID (see [Checking Payment Status](#checking-payment-status-tracking-id)). Values inside the app can be tampered with.

The `PaymentResult` contains the final transaction status:

```swift
private func handlePaymentSuccess(_ result: PaymentResult) {
    let status = result.transactionDetails.result ?? ""

    switch status {
    case "CAPTURED", "SUCCESS":
        print("Payment Succeeded!")
        print("Message: \(result.message)")
        print("Tracking ID: \(result.transactionDetails.trackingID ?? "N/A")")
        print("Payment ID: \(result.transactionDetails.paymentID ?? "N/A")")
        print("Transaction ID: \(result.transactionDetails.transactionID ?? "N/A")")
        print("Order ID: \(result.transactionDetails.orderID ?? "N/A")")
        print("Reference: \(result.transactionDetails.reference ?? "N/A")")

    case "CANCELED":
        print("User cancelled the payment.")
        // Dismiss checkout or prompt user to retry

    case "DECLINED":
        print("Payment declined by bank.")

    default:
        print("Transaction ended with status: \(status)")
    }
}

private func handlePaymentFailure(_ error: NetworkError) {
    if let details = error.errorDetails, !details.isEmpty {
        // Usually a programming mistake: a required field is missing.
        print("Validation errors: \(details.joined(separator: ", "))")
    } else {
        print("Payment failed: \(error.localizedDescription)")
    }
    // If the server rejected the charge, transaction info may be attached:
    if let trackingID = error.transactionDetails?.trackingID {
        print("Tracking ID: \(trackingID)")
    }
}
```

---

## 7. Additional Payment Features

### Checking Payment Status (Tracking ID)

Query the real-time status of a transaction at any time using its `trackingID`:

```swift
UPayments.shared.fetchPaymentStatus(trackingID: "TRK_123456789") { result in
    switch result {
    case .success(let response):
        let isSuccess = response.status ?? false
        let message = response.message ?? ""
        print("Status query: \(isSuccess ? "Success" : "Failed") - \(message)")
        if let transaction = response.data?.transaction {
            print("Transaction result: \(transaction.result ?? "")")
        }
    case .failure(let error):
        print("Failed to query status: \(error.localizedDescription)")
    }
}
```

> [!NOTE]
> `response.status` only tells you whether the **lookup** worked, not whether the payment succeeded. Check `response.data?.transaction?.result` for the payment outcome.
>
> The fields here use slightly different names from `TransactionDetails`: `trackId` instead of `trackingID`, and `paymentId` instead of `paymentID`. They refer to the same values.

### Checking Payment Button Status

Use this to decide which payment buttons to show in your UI.

**Easiest way:** after `configure` succeeds, the SDK has already loaded and cached your account's settings. Ask it directly:

```swift
knetButton.isHidden = !UPayments.shared.isPaymentAvailable(.knet)
cardButton.isHidden = !UPayments.shared.isPaymentAvailable(.creditCard)
applePayButton.isHidden = !UPayments.shared.isPaymentAvailable(.applePay)
```

`PaymentMethodType` cases: `.knet`, `.creditCard`, `.samsungPay`, `.applePay`, `.applePayKnet`, `.amex`, `.googlePay`, `.appleNative`. A raw-string version also exists: `isPaymentAvailable("knet")`.

> [!NOTE]
> `isPaymentAvailable` returns `false` until the settings have loaded. If you need fresh data, call `checkPaymentButtonStatus` and update the UI in its completion. That completion may run on a background thread, so switch to `DispatchQueue.main` before touching UI.

**Fresh lookup from the server:**

```swift
UPayments.shared.checkPaymentButtonStatus { result in
    switch result {
    case .success(let buttonStatus):
        print("KNET enabled: \(buttonStatus.isKnetEnabled)")
        print("Cards enabled: \(buttonStatus.isCreditCardEnabled)")
        print("Apple Pay enabled: \(buttonStatus.isApplePayEnabled)")
        print("Whitelabel account: \(buttonStatus.isWhiteLabel)")
        // Full map, e.g. ["knet": true, "cc": true, "apple-pay": true]:
        print(buttonStatus.paymentButtonData?.payButtons ?? [:])
    case .failure(let error):
        print("Failed to check button status: \(error.localizedDescription)")
    }
}
```

### Saved Cards & Customer Tokenization

**How the pieces fit together:**

```text
1. createCustomerToken  →  register a numeric ID for the customer (sent as a String);
                           UPayments returns the customer token as an Int. Save it in your database.
2. addCard              →  customer enters a card in a web view; it is stored against that token.
3. fetchCustomerCards   →  use the Int token to list saved cards. Each card has a `token` (String).
4. autoDeduct           →  charge a saved card using the Int customer token + the card's `token`.
```

> [!IMPORTANT]
> There are **two different tokens**. Don't mix them up:
>
> - **Customer token** (`Int`): identifies the customer. It comes from step 1.
> - **Card token** (`String`): identifies one saved card. It comes from step 3.

#### 1. Create a Customer Token

Send a unique **numeric** ID for the customer (for example, their numeric user ID in your system). The request takes it as a `String`; the response returns the customer token as an `Int`:

```swift
let tokenRequest = CustomerTokenRequestModel(customerUniqueToken: "12345") // numeric ID, as a String

UPayments.shared.createCustomerToken(request: tokenRequest) { result in
    switch result {
    case .success(let response):
        if let customerToken = response.data?.customerUniqueToken { // Int
            print("Customer token: \(customerToken)")
            // Save customerToken in your database, linked to this customer
        }
    case .failure(let error):
        print("Failed to create customer token: \(error.localizedDescription)")
    }
}
```

#### 2. Add a Customer Card

Open the card entry web view so the customer can securely save a card. `customerUniqueToken` and `returnUrl` are required:

```swift
let addCardRequest: [String: Any] = [
    "customerUniqueToken": 12345, // the customer token from step 1
    "returnUrl": "https://yourdomain.com/card/added"
]

UPayments.shared.addCard(
    cardRequest: addCardRequest,
    from: self
) { result in
    switch result {
    case .success(let responseDict):
        // Set when the card web view was shown and then closed:
        let status = responseDict["addCardStatusMessage"] ?? "n/a"
        print("Add-card flow finished. Status: \(status)")
        // Call fetchCustomerCards afterwards to confirm the card was saved.
    case .failure(let error):
        print("Failed to add card: \(error.localizedDescription)")
    }
}
```

#### 3. Fetch Saved Cards

Retrieve the stored cards using the **customer token (Int)** from step 1:

```swift
let tokenData = TokenDataModel(customerUniqueToken: 12345)

UPayments.shared.fetchCustomerCards(request: tokenData) { result in
    switch result {
    case .success(let response):
        let cards = response.data?.customerCardsInfo ?? []
        print("Customer has \(cards.count) saved card(s).")
        for card in cards {
            print("Card token: \(card.token ?? "")") // use this for autoDeduct
        }
    case .failure(let error):
        print("Failed to fetch cards: \(error.localizedDescription)")
    }
}
```

### Auto-Deduct (Recurring Billing)

Charge a saved card without any customer interaction (no UI is shown):

```swift
let autoDeductRequest = AutoDeductRequestModel(
    order: AutoDeductOrderModel(
        orderId: "REC_ORDER_998",
        currency: "KWD",
        amount: "15.00" // note: a String here, unlike OrderModel.amount (Double)
    ),
    language: "en",
    reference: AutoDeductReferenceModel(referenceId: "REC_REF_998"),
    customer: AutoDeductCustomerModel(uniqueToken: 12345),  // customer token (Int) from step 1
    card: AutoDeductCardModel(token: savedCard.token)       // card token (String) from fetchCustomerCards
)

UPayments.shared.autoDeduct(request: autoDeductRequest) { result in
    switch result {
    case .success(let response):
        print("Auto-deduct response: \(response)")
    case .failure(let error):
        print("Auto-deduct failed: \(error.localizedDescription)")
    }
}
```

### Invoicing

Create a payment invoice (a payment link UPayments can send to the customer by SMS or email). The request is a dictionary with the same nested shape as a payment request. `order`, `customer`, `reference`, `language`, and `returnUrl` are required:

```swift
let invoiceRequest: [String: Any] = [
    "order": [
        "id": "INV_ORDER_501",
        "currency": "KWD",
        "amount": 25.0
    ],
    "customer": [
        "name": "Ahmed Al-Mansoor",
        "email": "ahmed@example.com",
        "mobile": "96598765432"
    ],
    "reference": ["id": "INV_REF_501"],
    "language": "en",
    "returnUrl": "https://yourdomain.com/invoice/success",
    "cancelUrl": "https://yourdomain.com/invoice/cancel",
    "notificationUrl": "https://yourdomain.com/invoice/webhook"
]

UPayments.shared.createInvoice(request: invoiceRequest) { result in
    switch result {
    case .success(let invoice):
        print("Invoice created: \(invoice.message ?? "")")
        print("Invoice URL: \(invoice.details?.invoiceUrl ?? "")")
    case .failure(let error):
        print("Invoice creation failed: \(error.localizedDescription)")
    }
}
```

### Refunds (Single & Multi-Vendor)

#### Single Refund

`orderId` (the order you are refunding) and `totalPrice` (> 0) are required.

```swift
let refund = RefundRequestModel(
    orderId: "ORDER_12345",
    totalPrice: 10.0,
    customerFirstName: "Sara",
    customerEmail: "sara@example.com",
    customerMobileNumber: "96512345678",
    reference: "REFUND_001",
    notifyUrl: "https://yourdomain.com/refund/webhook"
)

UPayments.shared.createRefund(request: refund) { result in
    switch result {
    case .success(let response):
        print("Refund status: \(response.status ?? false)")
    case .failure(let error):
        print("Refund failed: \(error.localizedDescription)")
    }
}
```

#### Multi-Vendor Refund

Refund an order that was split between several vendors. Add one `MerchantMoreDetailsModel` per vendor (the list cannot be empty). Note that `amount` and the charges are `Int` values.

```swift
let multiRefund = MultiVendorRefundRequest(
    merchantMoreDetailModel: [
        MerchantMoreDetailsModel(amount: 20, kNetCharge: 1, iBanNumber: "KW00XXXX000000000000000000"),
        MerchantMoreDetailsModel(amount: 30, kNetCharge: 1, iBanNumber: "KW00YYYY000000000000000000")
    ]
)

UPayments.shared.createMultiVendorRefund(request: multiRefund) { result in
    switch result {
    case .success(let response):
        print("Multi-vendor refund status: \(response.status ?? false)")
    case .failure(let error):
        print("Multi-vendor refund failed: \(error.localizedDescription)")
    }
}
```

> [!NOTE]
> For refunds, `response.status == true` means the refund request was accepted. If it is `false`, check `response.message` and `response.data?.errorCode`.

#### Deleting (Cancelling) a Refund

Both delete calls take a dictionary and require the `order_id` key:

```swift
UPayments.shared.deleteRefund(request: ["order_id": "ORDER_12345"]) { result in
    switch result {
    case .success(let response):
        print("Refund deleted: \(response)")
    case .failure(let error):
        print("Delete refund failed: \(error.localizedDescription)")
    }
}

// Multi-vendor refunds use the same shape:
UPayments.shared.deleteMultiVendorRefund(request: ["order_id": "ORDER_12345"]) { result in
    // handle result the same way
}
```

---

## 8. API Reference

### Core Facade: `UPayments`

The main entry point for the SDK:

```swift
public final class UPayments {
    public static let shared: UPayments

    // Configuration
    public static func configure(
        apiKey: String,
        secretKey: String? = nil,
        environment: Environment = .sandbox,
        isWhitelabeled: Bool = false,
        appleIdentifier: AppleIdentifierModel? = nil,
        applePayConfiguration: ApplePayConfiguration? = nil,
        appleMerchantIdentifier: String? = nil,
        completion: ((Result<String, NetworkError>) -> Void)? = nil
    )
    public func setEnvironment(_ environment: Environment)
    public func configureApplePay(_ applePayConfig: ApplePayConfiguration)
    public func configureApplePay(with appleIdentifier: AppleIdentifierModel)
    public func register(paymentHandler: PaymentMethodHandler) // advanced: custom native payment methods

    // Payments
    public func processPayment(
        request: PaymentRequestModel,
        from presentingController: UIViewController,
        isBackground: Bool = false,
        apiKey: String? = nil,
        completion: @escaping (Result<PaymentResult, NetworkError>) -> Void
    )
    public func fetchPaymentStatus(
        trackingID: String,
        apiKey: String? = nil,
        completion: @escaping (Result<PaymentStatusResponseModel, NetworkError>) -> Void
    )
    public func checkPaymentButtonStatus(
        apiKey: String? = nil,
        completion: @escaping (Result<PaymentButtonStatusModel, NetworkError>) -> Void
    )
    public func checkPaymentButtonStatus(
        apiKey: String? = nil,
        source: String,
        completion: @escaping (Result<PaymentButtonStatusModel, NetworkError>) -> Void
    )
    public func isPaymentAvailable(_ method: PaymentMethodType) -> Bool
    public func isPaymentAvailable(_ method: String) -> Bool

    // Cards & Customers
    public func createCustomerToken(
        request: CustomerTokenRequestModel,
        apiKey: String? = nil,
        completion: @escaping (Result<CustomerTokenResponseModel, NetworkError>) -> Void
    )
    public func fetchCustomerCards(
        request: TokenDataModel,
        apiKey: String? = nil,
        completion: @escaping (Result<RetrieveCardResponseModel, NetworkError>) -> Void
    )
    public func addCard(
        cardRequest: [String: Any],
        from presentingController: UIViewController,
        isBackground: Bool = false,
        apiKey: String? = nil,
        completion: @escaping (Result<[String: Any], NetworkError>) -> Void
    )
    public func autoDeduct(
        request: AutoDeductRequestModel,
        apiKey: String? = nil,
        completion: @escaping (Result<[String: Any], NetworkError>) -> Void
    )

    // Invoices & Refunds
    public func createInvoice(
        request: [String: Any],
        apiKey: String? = nil,
        completion: @escaping (Result<InvoiceCreatedModel, NetworkError>) -> Void
    )
    public func createRefund(
        request: RefundRequestModel,
        apiKey: String? = nil,
        completion: @escaping (Result<RefundResponseModel, NetworkError>) -> Void
    )
    public func createMultiVendorRefund(
        request: MultiVendorRefundRequest,
        apiKey: String? = nil,
        completion: @escaping (Result<RefundResponseModel, NetworkError>) -> Void
    )
    public func deleteRefund(
        request: [String: Any],
        apiKey: String? = nil,
        completion: @escaping (Result<[String: Any], NetworkError>) -> Void
    )
    public func deleteMultiVendorRefund(
        request: [String: Any],
        apiKey: String? = nil,
        completion: @escaping (Result<[String: Any], NetworkError>) -> Void
    )
}
```

### Payment Request Models

All initializer parameters are optional and default to `nil`. The SDK validates the required ones at runtime (see [Step 2](#step-2-pre-flight-validation-rules)).

| Model                 | Initializer                                                                                                                                                                                                                                                                        | Notes                                                                                                                      |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------- |
| `PaymentRequestModel` | `products:`, `merchantsMoreInfo:`, `sessionID:`, `isTest:`, `order:`, `paymentGateway:`, `notificationType:`, `language:`, `isSaveCard:`, `isWhitelabeled:`, `tokens:`, `reference:`, `customer:`, `customerExtraData:`, `returnURL:`, `cancelURL:`, `notificationURL:`, `device:` | Leave`isWhitelabeled` unset; the SDK fills it in from your account settings.                                               |
| `OrderModel`          | `orderId:`, `reference:`, `description:`, `currency:`, `amount:` (`Double`)                                                                                                                                                                                                        |                                                                                                                            |
| `ProductModel`        | `name:`, `description:`, `price:` (`Double`), `quantity:` (`Double`)                                                                                                                                                                                                               |                                                                                                                            |
| `PaymentGatewayModel` | `src:`, `token:`                                                                                                                                                                                                                                                                   | `src`: `"knet"`, `"cc"`, `"apple-pay"`, … or `nil` to let the customer choose. Leave `token` unset; Apple Pay fills it in. |
| `ReferenceModel`      | `referenceId:`                                                                                                                                                                                                                                                                     |                                                                                                                            |
| `CustomerModel`       | `uniqueID:`, `name:`, `email:`, `mobile:`                                                                                                                                                                                                                                          |                                                                                                                            |

### Result Models: `PaymentResult` & `TransactionDetails`

Every method that takes an `apiKey:` parameter uses the key from `configure` when you leave it out. Pass it only to override that key for a single call.

```swift
public struct PaymentResult: Codable, Equatable {
    public var message: String                       // human-readable summary
    public var transactionDetails: TransactionDetails
    public var paymentDetails: PaymentDetailsModel?  // raw gateway details, when available
}

public struct TransactionDetails: Codable, Equatable {
    public var result: String?            // "CAPTURED", "SUCCESS", "CANCELED", "DECLINED", "FAILED"
    public var paymentID: String?
    public var trackingID: String?        // use with fetchPaymentStatus(trackingID:)
    public var transactionID: String?
    public var orderID: String?
    public var reference: String?
    public var paymentType: String?       // e.g. "knet", "cc", "apple-pay"
    public var invoiceID: String?
    public var authorizationCode: String?
    public var postingDate: String?
    public var receiptID: String?
    public var transactionUDF: String?
}
```

> Lower-case aliases (`paymentId`, `trackingId`, `transactionId`, `orderId`, `invoiceId`, `receiptId`) also exist for older code. They read and write the same values.

---

## 9. Error Handling

### The `NetworkError` Struct

All failures across all SDK methods return a `NetworkError`:

```swift
public struct NetworkError: Error, LocalizedError, CustomStringConvertible, Equatable {
    public let reason: String?
    public let httpStatusCode: Int?
    public let errorDetails: [String]?
    public let rawResponseBody: String?
    public let responseData: [String: Any]?
    public let transactionDetails: TransactionDetails?   // set when the server rejected a charge
    public let paymentDetails: PaymentDetailsModel?

    public var errorDescription: String? { get }
    public var formattedInDepthDescription: String { get }
}
```

#### Common Error Properties

- `error.reason`: A descriptive explanation of why the operation failed.
- `error.httpStatusCode`: The HTTP status code returned by the server or synthesized by the SDK (e.g., 400 for bad requests, 401 for unauthorized, 422 for client validation failures).
- `error.errorDetails`: An array of specific field failure messages (such as missing required fields).
- `error.transactionDetails`: When the server rejected a payment charge, the transaction info (order ID, reference, tracking ID if any).
- `error.formattedInDepthDescription`: A multi-line debug summary printing the status code, reason, validation details, and raw response body. Useful for logs, but don't show it to customers.

| `httpStatusCode` | Typical cause                                                                 |
| :--------------- | :---------------------------------------------------------------------------- |
| `422`            | The SDK's own validation failed; see`errorDetails`                            |
| `401`            | No API key;`configure` was not called (`NetworkError.credentialsNotResolved`) |
| `400`            | Server rejected the request, or an invalid payment link                       |
| others           | Returned by the UPayments server; see`reason` and `rawResponseBody`           |

### Cancellation Handling

When a user taps **Cancel** on the payment web view, swipes it away, or dismisses the Apple Pay sheet, the SDK returns **`.success(PaymentResult)`** (not `.failure`) where:

```swift
paymentResult.transactionDetails.result == "CANCELED"
```

This design ensures your payment controller is dismissed cleanly and you can resume normal UI operations without alerting the user of an unexpected error.

### Validation Failures

If required fields fail validation, the SDK returns a `NetworkError` with `httpStatusCode == 422` and the problems listed in `errorDetails`. This applies to all methods that validate input (payments, cards, auto-deduct, invoices, refunds):

```swift
case .failure(let error):
    if error.httpStatusCode == 422 {
        print("Validation failed:")
        error.errorDetails?.forEach { print(" • \($0)") }
    }
```

---

## 10. Backward Compatibility

> **New integrations: skip this section** and use `UPayments.shared` as shown above.

Older apps that used the legacy `PaymentGatewayImplementation` / `PaymentAPIManager` API keep working without changes:

```swift
// Existing integrations using PaymentGatewayImplementation or PaymentAPIManager continue to work:
let paymentManager = PaymentGatewayImplementation.shared.paymentStoreUseCase
paymentManager.setBaseURL(environment: .sandbox)

paymentManager.createPayment(
    isBackground: false,
    token: "YOUR_API_KEY",
    paymentRequestDetails: paymentRequest,
    controller: self
) { result in
    // Handled seamlessly
}
```

---

## 11. Production Checklist

Before submitting your application to the App Store or enabling live customer payments:

- [ ] **SDK Environment**: Set to `.production` in `UPayments.configure(...)`.
- [ ] **API Key**: Using your live Production API Key from the UPayments portal.
- [ ] **Payment Request Flag**: `isTest` is set to `false` (or omitted).
- [ ] **Pre-Flight Required Fields**: Validated `order.amount > 0`, `order.currency`, `language`, `reference.referenceId`, `returnURL`, `cancelURL`, and `notificationURL`.
- [ ] **HTTPS Server Callbacks**: Confirmed that `returnURL`, `cancelURL`, and `notificationURL` point to secure, publicly accessible HTTPS endpoints.
- [ ] **Webhook Handling**: Confirmed your backend receives and verifies webhook notifications sent to `notificationURL`.
- [ ] **Apple Pay Setup (if applicable)**:
  - Production Apple Merchant ID configured in Xcode entitlements.
  - Apple Pay Payment Processing Certificate active in Apple Developer Portal and UPayments dashboard.
  - Tested on a physical device with a real payment card.
- [ ] **Server-side verification**: Orders are fulfilled only after your backend confirms the payment (webhook or status lookup), not just from the in-app result.
- [ ] **Keys not hard-coded**: The live API key/secret key is not committed to source control or hard-coded in the release build.
- [ ] **UI Presentation**: Verified that the view controller passed to `from:` is currently visible in the active window hierarchy.

---

## 12. Troubleshooting & FAQs

### Q1: Why do I receive HTTP 422 Validation Error immediately?

- Pre-flight validation caught a missing required field.
- Check `error.errorDetails`. Common missing fields include:
  - `language` (must be `"en"` or `"ar"`)
  - `reference.referenceId` (must be non-empty)
  - `returnURL`, `cancelURL`, or `notificationURL` (cannot be empty strings)
  - `order.amount` (must be strictly greater than 0)

### Q2: Why do I receive `credentialsNotResolved` (HTTP 401)?

- Ensure you called `UPayments.configure(apiKey: "...", environment: ...)` before initiating any payment or card operations.
- Ensure your API Key is valid and active in the UPayments Merchant Dashboard.

### Q3: Why does the web view dismiss immediately without showing payment?

- Verify that the URL string returned in the payment link is valid.
- If your device is offline or has invalid DNS, the web view encounters a navigation error and dismisses automatically, returning a `NetworkError` with the underlying connection code.

### Q4: How do I support both English and Arabic?

- Set `paymentRequest.language = "ar"` for Arabic or `"en"` for English. The web checkout interface and native buttons adapt accordingly.

### Q5: Can I test on the iOS Simulator?

- Yes. For KNET and credit cards, the full web flow works normally in the simulator.
- For Apple Pay there is **no mock**. If the native Apple Pay sheet can't be shown (common in the simulator), the SDK falls back to the web checkout. Test native Apple Pay on a physical device.

### Q6: I set `paymentGateway.src = "apple-pay"` but I see a web page instead of the Apple Pay sheet. Why?

- That page is the hosted Apple Pay screen. It's shown whenever your account isn't allowed to use Apple Pay native. The native sheet needs **all** of these: a whitelabel account, Apple Pay native allowed by UPayments, Apple Pay or Apple Pay KNET enabled in the merchant portal (Upay Merchants App), and Apple Pay configured in the app. See [When is the native Apple Pay sheet shown?](#when-is-the-native-apple-pay-sheet-shown).
- If Apple Pay is disabled in the merchant portal, you get an error instead. Call `checkPaymentButtonStatus` first so you never show a disabled button.

### Q7: My payment returned `.success` but the order wasn't paid. Why?

- `.success` only means the flow finished. Check `transactionDetails.result`. A `"DECLINED"`, `"FAILED"`, or `"CANCELED"` result also arrives as `.success`. See [Step 4](#step-4-inspect-the-payment-result).

---

## Need Technical Support?

- **UPayments Developer Documentation**: [https://developers.upayments.com](https://developers.upayments.com)
- **Merchant Dashboard**: [https://my.upayments.com](https://my.upayments.com)
- **Technical Inquiries**: `support@upayments.com` / `license@upayments.com`
