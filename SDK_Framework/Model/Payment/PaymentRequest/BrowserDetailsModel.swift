//
//  BrowserDetailsModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Detailed information about the browser used in the payment request.
public struct BrowserDetailsModel: Codable {
    
    /// Width of the browser screen.
    public let screenWidth: String?
    /// Height of the browser screen.
    public let screenHeight: String?
    /// Color depth of the browser screen.
    public let colorDepth: String?
    /// Indicates whether Java is enabled in the browser.
    public let javaEnabled: String?
    /// Language setting of the browser.
    public let language: String?
    /// Time zone of the browser.
    public let timeZone: String?

    /// Initializes a new instance of `BrowserDetailsModel`.
    /// - Parameters:
    ///   - screenWidth: Width of the browser screen.
    ///   - screenHeight: Height of the browser screen.
    ///   - colorDepth: Color depth of the browser screen.
    ///   - javaEnabled: Indicates whether Java is enabled in the browser.
    ///   - language: Language setting of the browser.
    ///   - timeZone: Time zone of the browser.
    public init(screenWidth: String? = nil, screenHeight: String? = nil, colorDepth: String? = nil, javaEnabled: String? = nil, language: String? = nil, timeZone: String? = nil) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.colorDepth = colorDepth
        self.javaEnabled = javaEnabled
        self.language = language
        self.timeZone = timeZone
    }
}
