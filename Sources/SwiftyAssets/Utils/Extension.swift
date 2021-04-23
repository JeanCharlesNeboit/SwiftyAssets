//
//  Extension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

enum Extension: String {
    case swift = ".swift"
    case strings = ".strings"
    case xcassets = ".xcassets"
    case json = ".json"
    case lproj = ".lproj"
    case colorset = ".colorset"
    case imageset = ".imageset"
    case yaml = ".yml"
    case csv = ".csv"
    case png = ".png"
    case svg = ".svg"

    var withoutDot: String {
        return rawValue.replacingOccurrences(of: ".", with: "")
    }
}
