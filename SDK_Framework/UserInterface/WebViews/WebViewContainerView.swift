//
//  WebViewContainerView.swift
//  uInterfaceSDK
//
//  Created by user on 22/08/24.
//

import UIKit
import WebKit

/// A custom UIView subclass that contains a WKWebView with preconfigured settings and constraints.
class WebViewContainerView: UIView {
    
    /// The WKWebView instance used to display web content.
    var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    // MARK: - Initializers
    
    /// Initializes the WebViewContainerView with default settings.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(webView)
        setupConstraints()
    }
    
    /// This initializer is required for loading the view from a storyboard or nib.
    /// It has not been implemented as this view is intended to be created programmatically.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /// Sets up the constraints for the web view to fill the entire view.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.rightAnchor.constraint(equalTo: rightAnchor),
            webView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}
