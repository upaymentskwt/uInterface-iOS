//
//  DeviceModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents device details from which the payment request is initiated.
public struct DeviceModel: Codable {
    
    /// Browser information of the device.
    public let browser: String?
    /// Detailed browser information, if available.
    public let browserDetails: BrowserDetailsModel?

    /// Initializes a new instance of `DeviceModel`.
    /// - Parameters:
    ///   - browser: Browser information of the device.
    ///   - browserDetails: Detailed browser information, if available.
    public init(browser: String? = nil, browserDetails: BrowserDetailsModel? = nil) {
        self.browser = browser
        self.browserDetails = browserDetails
    }
}
