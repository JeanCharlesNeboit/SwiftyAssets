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
    
    override init(input: String, output: String) throws {
        try super.init(input: input, output: output)
        
        for namedRow in csv.namedRows {
            if let name = namedRow[ColorHeader.name.rawValue],
                let light = namedRow[ColorHeader.light.rawValue] {
                let dark = namedRow[ColorHeader.dark.rawValue]
                
                colors.append(Color(name: name, lightHex: light, darkHex: dark))
            }
        }
    }
}
