//
//  StringExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 10/02/2020.
//

import Foundation

extension String {
    func lowercasedFirst() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func lowercasedFirst() {
        self = self.lowercasedFirst()
    }
    
    func removeWhitespaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    mutating func removeWhitespaces() {
        self = self.removeWhitespaces()
    }
}
