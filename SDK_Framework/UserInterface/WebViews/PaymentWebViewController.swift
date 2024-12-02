//
//  PaymentWebViewController.swift
//  uInterfaceSDK
//
//  Created by user on 22/08/24.
//

import UIKit
import WebKit

/// A view controller that handles displaying web content related to payment processing.
public class PaymentWebViewController: UIViewController {

    /// Completion handler that returns the result of the payment process.
    public var onPaymentCompletion: ((Result<PaymentResult, NetworkError>) -> Void)?

    /// The URL to be loaded in the web view.
    public var paymentURL: URL?

    /// The custom view containing the web view for displaying the payment page.
    private var webViewContainer: WebViewContainerView = WebViewContainerView()

    /// Details about the payment request.
    public var paymentRequestDetails: PaymentRequestModel?

    /// A flag indicating whether the app was sent to the background during the process.
    public var didEnterBackground: Bool?

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Add a script to disable zooming in the web view.
        webViewContainer.webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())

        // Set the web view's scroll view delegate and navigation delegate.
        webViewContainer.webView.scrollView.delegate = self
        webViewContainer.webView.navigationDelegate = self

        // Load the appropriate URL in the web view.
        loadPaymentURL()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // If the app was sent to the background during the process, return a failure result.
        if didEnterBackground == true {
            var emptyTransactionDetails = TransactionDetails()
            emptyTransactionDetails.reference = ""
            emptyTransactionDetails.transactionID = ""
            emptyTransactionDetails.paymentType = ""
            emptyTransactionDetails.receiptID = ""
            emptyTransactionDetails.orderID = ""
            emptyTransactionDetails.transactionUDF = ""
            emptyTransactionDetails.requestedOrderID = ""
            emptyTransactionDetails.authorizationCode = ""
            emptyTransactionDetails.postingDate = ""
            emptyTransactionDetails.result = ""
            emptyTransactionDetails.trackingID = ""
            emptyTransactionDetails.paymentID = ""
            emptyTransactionDetails.refundOrderID = ""
            let paymentResult = PaymentResult(message: "Payment failed", transactionDetails: emptyTransactionDetails)
            onPaymentCompletion?(.success(paymentResult))
        }
    }

    // MARK: - Private Methods

    /// Returns a WKUserScript that disables zooming in the web view.
    private func getZoomDisableScript() -> WKUserScript {
        let source = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            var head = document.getElementsByTagName('head')[0];
            head.appendChild(meta);
            """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }

    /// Loads the appropriate payment URL in the web view.
    private func loadPaymentURL() {
        guard let url = paymentURL?.absoluteString else { return }
        
        if url.contains("get-pay-by-samsung") {
            paymentURL = URL(string: "https://apiv2api.upayments.com/get-pay-by-samsung?order_id=p8PS2GtfrGodZxD74RNzby9cDfsEP399&track_id=2tab587HaYmxfEf5kJRo0HWNSvOMuON3&transaction_id=2328669&ref_id=15269530&currency=KWD&amount=40.000&success_url=https://upayments.com/en/&failure_url=https://developers.upayments.com/")
        }
        
        if let paymentURL = paymentURL {
            let request = URLRequest(url: paymentURL)
            webViewContainer.webView.load(request)
        }
    }

    // MARK: - View Management

    public override func loadView() {
        view = webViewContainer
    }
}

/// Extension to handle navigation events in `PaymentWebViewController`.
extension PaymentWebViewController: WKNavigationDelegate {
    
    /// Called when the web view finishes loading a page.
    /// - Parameters:
    ///   - webView: The `WKWebView` instance that finished loading.
    ///   - navigation: The navigation object containing information about the page load.
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("Page finished loading.")
    }
    
    /// Called when the web view receives a server redirect during provisional navigation.
    /// - Parameters:
    ///   - webView: The `WKWebView` instance that received the redirect.
    ///   - navigation: The navigation object containing information about the redirect.
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("Received server redirect: \(navigation.debugDescription)")
    }
    
    /// Called when the web view starts loading a page.
    /// - Parameters:
    ///   - webView: The `WKWebView` instance that started loading.
    ///   - navigation: The navigation object containing information about the provisional navigation.
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("Started provisional navigation.")
    }
    
    /// Decides whether to allow or cancel a navigation action.
    /// - Parameters:
    ///   - webView: The `WKWebView` instance asking for the decision.
    ///   - navigationAction: The navigation action requesting a decision.
    ///   - decisionHandler: The closure to call with the decision (allow or cancel).
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let urlString = navigationAction.request.url?.absoluteString {
            // Check for specific result types in the URL.
            if urlString.contains("CAPTURED") || urlString.contains("DECLINED") || urlString.contains("CANCELED") {
                didEnterBackground = false
                decisionHandler(.cancel)
                self.dismiss(animated: true) {
                    // Parse the URL and return the payment result.
                    self.onPaymentCompletion?(.success(self.parsePaymentResult(from: urlString)))
                }
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// Parses the URL query string to extract payment result details.
    /// - Parameter urlString: The URL string to be parsed.
    /// - Returns: A `PaymentResult` containing the parsed details.
    private func parsePaymentResult(from urlString: String) -> PaymentResult {
        var queryParameters: [String: String] = [:]
        
        if let urlComponents = URLComponents(string: urlString),
           let queryItems = urlComponents.queryItems {
            // Convert query items to a dictionary.
            for item in queryItems {
                queryParameters[item.name] = item.value
            }
        }
        
        // Create and populate the transaction details.
        var transactionDetails = TransactionDetails()
        transactionDetails.reference = queryParameters["ref"] ?? ""
        transactionDetails.transactionID = queryParameters["tran_id"] ?? ""
        transactionDetails.paymentType = queryParameters["payment_type"] ?? ""
        transactionDetails.receiptID = queryParameters["receipt_id"] ?? ""
        transactionDetails.orderID = queryParameters["order_id"] ?? ""
        transactionDetails.transactionUDF = queryParameters["trn_udf"] ?? ""
        transactionDetails.requestedOrderID = queryParameters["requested_order_id"] ?? ""
        transactionDetails.authorizationCode = queryParameters["auth"] ?? ""
        transactionDetails.postingDate = queryParameters["post_date"] ?? ""
        transactionDetails.result = queryParameters["result"] ?? ""
        transactionDetails.trackingID = queryParameters["track_id"] ?? ""
        transactionDetails.paymentID = queryParameters["payment_id"] ?? ""
        transactionDetails.refundOrderID = queryParameters["refund_order_id"] ?? ""
        
        // Determine the result based on the parsed details.
        let resultMessage = transactionDetails.result == "CAPTURED" ? "Payment succeeded" : "Payment failed"
        return PaymentResult(message: resultMessage, transactionDetails: transactionDetails)
    }
}

// MARK: - UIScrollViewDelegate Extension for WebViewController

extension PaymentWebViewController: UIScrollViewDelegate {
    
    /// Called when the scroll view is about to start zooming.
    /// - Parameters:
    ///   - scrollView: The `UIScrollView` instance that is about to start zooming.
    ///   - view: The view that will be zoomed.
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // Disable pinch gesture recognizer to prevent zooming.
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    /// Returns the view that will be zoomed by the scroll view.
    /// - Parameter scrollView: The `UIScrollView` instance requesting the view for zooming.
    /// - Returns: Always returns `nil` to prevent zooming.
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
