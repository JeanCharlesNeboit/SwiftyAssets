//
//  Language.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

struct Language {
    let code: String
    let country: String
    let translatedStrings: [String]
    
    var flag: String {
        let base: UInt32 = 127397
        var flag = ""
        country.uppercased().unicodeScalars.forEach { value in
            flag.unicodeScalars.append(UnicodeScalar(base + value.value)!)
        }
        return flag
    }
}
