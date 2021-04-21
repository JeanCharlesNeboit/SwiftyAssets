//
//  CollectionExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 28/09/2020.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary where Key == String, Value == Any {
    static func += (lhs: inout [String:Any], rhs: [String:Any]) {
        for (key, value) in rhs {
            lhs.updateValue(value, forKey: key)
        }
    }
}
