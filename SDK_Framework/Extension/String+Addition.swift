//
//  String+Addition.swift
//  uInterfaceSDK
//
//  Created by user on 22/08/24.
//

import Foundation

// MARK: - String Extension

extension String {
    
    /// Splits the string into substrings using the specified regular expression pattern.
    /// - Parameter regexPattern: The regular expression pattern used for splitting the string.
    /// - Returns: An array of substrings split by the pattern, or the original string if the pattern is invalid.
    func split(usingRegexPattern regexPattern: String) -> [String] {
        // Attempt to create a regular expression object with the provided pattern.
        guard let regex = try? NSRegularExpression(pattern: regexPattern) else {
            // Return the original string as the only element if the pattern is invalid.
            return [self]
        }
        
        // Find matches for the regular expression in the string.
        let nsRange = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex.matches(in: self, range: nsRange)
        
        // Generate substrings from the ranges.
        var substrings: [String] = []
        var lastRangeEnd = self.startIndex
        
        for match in matches {
            guard let matchRange = Range(match.range, in: self), lastRangeEnd < matchRange.lowerBound else {
                continue
            }
            
            // Add the substring between the end of the last match and the start of the current match.
            substrings.append(String(self[lastRangeEnd..<matchRange.lowerBound]))
            lastRangeEnd = matchRange.upperBound
        }
        
        // Append the final substring after the last match.
        if lastRangeEnd < self.endIndex {
            substrings.append(String(self[lastRangeEnd..<self.endIndex]))
        }
        
        return substrings
    }

}
