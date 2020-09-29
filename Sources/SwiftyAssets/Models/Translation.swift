//
//  Translation.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 28/09/2020.
//

import Foundation

struct Translation {
    let key: String
    let value: String
}

extension Translation: Comparable {
    static func < (lhs: Translation, rhs: Translation) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func == (lhs: Translation, rhs: Translation) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
