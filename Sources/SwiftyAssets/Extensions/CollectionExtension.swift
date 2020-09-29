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
