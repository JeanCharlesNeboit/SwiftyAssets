//
//  ArrayStringExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

extension Array where Element == String {
    mutating func appendToLast(newElement: String) {
        if let last = self.last {
            self.removeLast()
            self.append("\(last),")
        }
    }
}
