//
//  Translation.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 28/09/2020.
//

import Foundation

struct Localizable {
    let key: String
    let value: String
}

struct LocalizableWithFormat {
    let key: String
    let value: [String: String]
}

extension Localizable: Comparable {
    static func < (lhs: Localizable, rhs: Localizable) -> Bool {
        return lhs.key < rhs.key
    }

    static func == (lhs: Localizable, rhs: Localizable) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
