//
//  Locale.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 28/09/2020.
//

import Foundation

struct Locale: Hashable {
    let id: String
    
    var language: String? {
        return id.components(separatedBy: "_")[safe: 0]
    }

    var country: String? {
        return id.components(separatedBy: "_")[safe: 1]
    }
    
    var flag: String {
        let base: UInt32 = 127397

        var flag = ""
        country?.uppercased().unicodeScalars.forEach { value in
            flag.unicodeScalars.append(UnicodeScalar(base + value.value)!)
        }

        return flag
    }
}

extension Locale: Comparable {
    static func < (lhs: Locale, rhs: Locale) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Locale, rhs: Locale) -> Bool {
        return lhs.id == rhs.id
    }
}
