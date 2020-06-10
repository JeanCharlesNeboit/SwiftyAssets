//
//  ColorCSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation

class ColorsCSVParser: CSVParser {
    private(set) var colors: [ColorSet] = []
    
    override init(path: String) throws {
        try super.init(path: path)
        
        for namedRow in csv.namedRows {
            guard let name = namedRow[ColorKeys.name.rawValue],
                let light = namedRow[ColorKeys.light.rawValue] else {
                return
            }
            
            var dark = namedRow[ColorKeys.dark.rawValue]
            if dark?.isEmpty == true { dark = nil }
            
            if let colorSet = try ColorSet(name: name, lightHex: light, darkHex: dark) {
                colors.append(colorSet)
            }
        }
    }
}
