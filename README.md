# UInterface iOS Example Application

A modern, native iOS reference application demonstrating the full feature set of `uInterfaceSDK`. Built with **SwiftUI**, **MVVM**, and **Clean Architecture** patterns.

---

## Features & Test Modules

This application provides dedicated, end-to-end interactive test flows for all UPayments payment gateway capabilities:

### 1. ⚙️ Environment & Settings
- Switch seamlessly between **Sandbox** and **Production** environments.
- Enable or disable **White-Label** branding mode.
- Configure and persist API Keys, Merchant Tokens, and HMAC Secrets.
- Live API Key format verification and credentials reset.

### 2. 💳 Checkout & Payment Processing
- Configure test orders with single or multi-product baskets.
- Customize customer details (Name, Email, Mobile number).
- Launch the payment flow via `PaymentGatewayImplementation.shared.processPayment(...)`.
- Built-in 3DS Web Coordinator with interactive WKWebView presentation.
- Instant transaction result display with status badges, reference IDs, and formatted JSON inspector.

### 3. 🗂️ Card Management & Tokenization
- Generate customer tokens on demand (`CustomerUniqueTokenUseCase`).
- Save new cards securely via the 3DS `addCard(...)` web flow.
- Retrieve and render tokenized cards as realistic, branded card tiles (brand, masked number, expiry).
- Inspect raw card payload and tokens.

### 4. 🔄 Auto-Deduct (Recurring Charges)
- Charge previously tokenized customer cards directly without user re-authentication.
- Supports order metadata, amount configuration, and currency selection.
- Detailed transaction response inspection.

### 5. 🧾 Invoicing
- Generate dynamic payment invoices and shareable payment URLs via `createInvoice(...)`.
- Configure multi-item orders with automated line-item calculations.
- Display generated invoice links with one-tap copy and browser preview.

### 6. 💸 Refunds
- **Single Refund**: Issue partial or full refunds against existing payment transactions.
- **Multi-Vendor Refund**: Distribute refunds across multiple merchant/vendor accounts.
- **Delete Refund**: Cancel pending refund requests before settlement.

### 7. 🔍 Status & Diagnostics
- **Payment Status**: Query real-time transaction lifecycle by Tracking ID (`getPaymentStatus(...)`).
- **Pay Buttons Status**: Query merchant-enabled payment buttons and gateway channels (`getPaymentButtonsStatus(...)`).

---

## Architecture & Project Structure

The example application follows Clean Architecture and MVVM principles:

```
UInterfaceIOS/
├── Core/
│   ├── AppConfiguration.swift       # Centralized observable environment & credentials state
│   └── WindowHelper.swift           # Utility to resolve root UIViewController for web coordinators
├── UI/
│   ├── Theme/
│   │   └── AppTheme.swift           # Brand colors, typography, glassmorphism cards, gradients
│   ├── Components/
│   │   ├── ActionButton.swift       # Standardized primary/secondary buttons with loading spinner
│   │   ├── FormInputField.swift     # Reusable form field with floating label & clear button
│   │   ├── GlassCard.swift          # Glassmorphic card modifier with border glow
│   │   ├── JSONResponseSheet.swift  # Monospaced interactive JSON response viewer with copy action
│   │   └── StatusBadge.swift        # Colored status badges (Success, Pending, Failed, Info)
│   ├── Navigation/
│   │   └── MainTabView.swift        # Modern bottom navigation bar for all 7 modules
│   └── Screens/
│       ├── Settings/                # Environment toggle, credentials configuration
│       ├── Checkout/                # 3DS Payment Checkout flow
│       ├── Cards/                   # Card tokenization and saved cards gallery
│       ├── AutoDeduct/              # Direct card token recurring payment
│       ├── Invoicing/               # Invoice creation and link generation
│       ├── Refunds/                 # Single, Multi-vendor, and Delete refund flows
│       └── Status/                  # Tracking ID query and payment button diagnostics
```

### Xcode Group Invariant
All PBXGroups in `UInterfaceIOS.xcodeproj` strictly mirror disk folders 1:1. No virtual groups, aliases, or symlinks.

---

## Getting Started

### Requirements
- **macOS Sonoma** or later
- **Xcode 15.0+**
- **iOS 15.0+** deployment target
- **CocoaPods** (for workspace integration)

### Running the Application

1. Open `UInterfaceIOS.xcworkspace` in Xcode:
   ```bash
   open UInterfaceIOS.xcworkspace
   ```
2. Select the `UInterfaceIOS` scheme.
3. Choose an iOS Simulator (e.g. *iPhone 17* or *iPhone 15 Pro*).
4. Press `Cmd + R` to build and run.

The workspace is pre-configured with the sibling `uInterfaceSDK.xcodeproj` project reference, enabling live development and debugging across both the SDK and Example App simultaneously.
