//
//  StringsYAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 30/07/2020.
//

import Foundation

typealias LocalizableStrings = [Locale: [Translation]]

class StringsYAMLParser: YAMLParser {
    private(set) var localizableStrings: LocalizableStrings = [:]
    
    override init(path: String) throws {
        try super.init(path: path)

        loadedDictionary.keys.forEach { key in
            if let values = loadedDictionary[key] as? [String: Any] {
                values.keys.forEach { language in
                    let value = values[language] as? String ?? ""
                    (localizableStrings[Locale(id: language), default: []]).append(Translation(key: key, value: value))
                }
            }
        }
    }
}
