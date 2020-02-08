//
//  StringsCSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation

class StringsCSVParser: CSVParser {
    private(set) var languages: [Language] = []
    private(set) var keys: [String]?
    
    override init(input: String, output: String) throws {
        try super.init(input: input, output: output)
        
        let locales = Array(csv.enumeratedRows[0].dropFirst())
        for locale in locales {
            if let translatedColumn = csv.enumeratedColumns.first(where: { (column) -> Bool in
                column.rows.first == locale
            }) {
                let translatedStrings = Array(translatedColumn.rows.dropFirst())
                let components = locale.components(separatedBy: "_")
                if components.count == 2 {
                    let code = components[0]
                    let country = components[1]
                    
                    languages.append(Language(code: code, country: country, translatedStrings: translatedStrings))
                }
            }
            
        }
        keys = Array(csv.enumeratedColumns[0].rows.dropFirst())
    }
}
