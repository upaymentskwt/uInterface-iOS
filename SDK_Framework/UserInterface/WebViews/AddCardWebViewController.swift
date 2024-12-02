//
//  WebViewAddCardViewController.swift
//  uInterfaceSDK
//
//  Created by user on 22/08/24.
//

import UIKit
import WebKit

/// ViewController responsible for displaying a web view to add a card.
class AddCardWebViewController: UIViewController, UIScrollViewDelegate {

    /// The URL to be loaded in the web view.
    public var cardAdditionURL: URL?

    /// UI component containing the web view.
    private var webViewContainer: WebViewContainerView = WebViewContainerView()

    /// Flag indicating whether the back button was pressed.
    public var isBackButtonPressed: Bool?

    /// Completion handler that returns the result of the card addition process.
    public var onCardAdditionCompletion: ((_ response: String) -> Void)?

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable zooming on the web view.
        // webViewUI.webView.configuration.userContentController.addUserScript(disableZoomScript())

        webViewContainer.webView.scrollView.delegate = self
        webViewContainer.webView.navigationDelegate = self

        // Load the card addition URL if it is valid.
        if let url = cardAdditionURL {
            let request = URLRequest(url: url)
            webViewContainer.webView.load(request)
        }
    }

    /// Overrides the loadView method to set up the view with the web view UI.
    public override func loadView() {
        view = webViewContainer
    }

    /// Called when the view disappears, checks if the back button was pressed and triggers the completion handler if needed.
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBackButtonPressed == true {
            onCardAdditionCompletion?("Add card process cancelled.")
        }
    }

    // MARK: - Private Methods

    /// Returns a WKUserScript that disables zooming on the web view.
    /// - Returns: A WKUserScript to disable zoom functionality.
    private func disableZoomScript() -> WKUserScript {
        let source: String = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            var head = document.getElementsByTagName('head')[0];
            head.appendChild(meta);
            """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}

/// Extension to handle navigation-related delegate methods for `AddCardWebViewController`.
extension AddCardWebViewController: WKNavigationDelegate {
    
    /// Called when the web view finishes loading a page.
    /// - Parameters:
    ///   - webView: The web view that finished loading the page.
    ///   - navigation: The navigation object containing details of the load request.
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("Page finished loading.")
    }

    /// Called when the web view receives a server redirect during provisional navigation.
    /// - Parameters:
    ///   - webView: The web view that received the redirect.
    ///   - navigation: The navigation object containing details of the redirect.
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("Received server redirect for provisional navigation: \(navigation.debugDescription)")
    }

    /// Called when the web view starts loading a page.
    /// - Parameters:
    ///   - webView: The web view that started loading.
    ///   - navigation: The navigation object containing details of the load request.
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("Started provisional navigation.")
    }

    /// Decides whether to allow or cancel a navigation action.
    /// - Parameters:
    ///   - webView: The web view that is about to navigate.
    ///   - navigationAction: The navigation action that triggered the decision.
    ///   - decisionHandler: The closure to call with the decision policy.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString {
            debugPrint("Navigating to URL: \(urlString)")
            
            // Check if the URL contains the specified string to cancel the navigation.
            if urlString.contains("https://upayments.com/en/") {
                isBackButtonPressed = false
                decisionHandler(.cancel)
                self.dismiss(animated: true) {
                    self.onCardAdditionCompletion?("Add card process completed.")
                }
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
