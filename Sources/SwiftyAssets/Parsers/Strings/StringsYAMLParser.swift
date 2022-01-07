//
//  StringsYAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 30/07/2020.
//

import Foundation

typealias Localizables = [Locale: [Localizable]]
typealias LocalizablesWithFormat = [Locale: [LocalizableWithFormat]]

protocol StringsParser {
    var localizables: Localizables { get }
    var localizableWithFormat: LocalizablesWithFormat { get }
}

class StringsYAMLParser: YAMLParser, StringsParser {
    private(set) var localizables = Localizables()
    private(set) var localizableWithFormat = LocalizablesWithFormat()
    
    override init(path: String) throws {
        try super.init(path: path)

        loadedDictionary.keys.forEach { key in
            if let values = loadedDictionary[key] as? [String: Any] {
                values.keys.forEach { language in
                    let locale = Locale(id: language)
                    let values = values[language]
                    
                    if let value = values as? String {
                        (localizables[locale, default: []]).append(.init(key: key, value: value))
                    } else if var plurals = values as? [String: String] {
                        guard plurals.keys.contains(PluralRuleValue.other()) else {
                            LoggerService.shared.error(message: "Plural rules must at least contain 'other' key.")
                            return
                        }
                        
                        let type = plurals["type"] ?? "d"
                        plurals.removeValue(forKey: "type")
                        (localizableWithFormat[locale, default: []]).append(.init(key: key, type: type, value: plurals))
                    } else {
                        LoggerService.shared.error(message: "Wrong syntax for '\(key)' string key in \(language) \(locale.flag)")
                    }
                }
            }
        }
    }
}
