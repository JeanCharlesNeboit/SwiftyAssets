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
}

struct AssetsSet {
    static var info: [String] {
        return [
            "\(String(repeating: "\t", count: 1))\"info\" : {",
            "\(String(repeating: "\t", count: 2))\"author\" : \"xcode\",",
            "\(String(repeating: "\t", count: 2))\"version\" : 1",
            "\(String(repeating: "\t", count: 1))}"
        ]
    }
}
