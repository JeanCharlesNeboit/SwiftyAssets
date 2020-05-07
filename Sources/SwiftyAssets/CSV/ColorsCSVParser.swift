//
//  ColorCSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation

fileprivate enum ColorHeader: String {
    case name = "Name"
    case light = "Light"
    case dark = "Dark"
}

class ColorsCSVParser: CSVParser {
    private(set) var colors: [Color] = []
    
    override init(path: String) throws {
        try super.init(path: path)
        
        for namedRow in csv.namedRows {
            guard let name = namedRow[ColorHeader.name.rawValue],
                let light = namedRow[ColorHeader.light.rawValue] else {
                return
            }
            
            var dark = namedRow[ColorHeader.dark.rawValue]
            if dark?.isEmpty == true { dark = nil }
            colors.append(Color(name: name, lightHex: light, darkHex: dark))
        }
    }
}

enum ColorsCSVParserError: Error {

}
