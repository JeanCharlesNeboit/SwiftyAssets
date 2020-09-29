//
//  YAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/06/2020.
//

import Yams

class YAMLParser {
    let loadedDictionary: [String: Any]

    init(path: String) throws {
        let mapYAML = try String(contentsOfFile: path, encoding: .utf8)
        loadedDictionary = try Yams.load(yaml: mapYAML) as? [String: Any] ?? [:]
    }
}
