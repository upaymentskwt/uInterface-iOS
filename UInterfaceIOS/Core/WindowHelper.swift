//
//  WindowHelper.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import UIKit

/// Helper utility to find the active topmost view controller for presenting SDK web flows.
public enum WindowHelper {
    
    /// Returns the currently active top-most UIViewController across all window scenes.
    public static var topMostViewController: UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let window = scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
        
        var top = window?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
