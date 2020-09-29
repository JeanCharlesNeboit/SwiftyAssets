//
//  AssetSet.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 30/07/2020.
//

import Foundation

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
