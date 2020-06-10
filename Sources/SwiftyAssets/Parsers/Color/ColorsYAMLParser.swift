//
//  ColorsYAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/05/2020.
//

import Foundation
import Yams

class ColorsYAMLParser: YAMLParser {
    var colors = [ColorSet]()
    
    override init(path: String) throws {
        try super.init(path: path)
        
        try loadedDictionary.keys.forEach({ key in
            let name = key
            if let value = loadedDictionary[key] as? [String: Any],
                let light = value[ColorKeys.light.rawValue] as? String {
                let dark = value[ColorKeys.dark.rawValue] as? String
                if let colorSet = try ColorSet(name: name, lightHex: light, darkHex: dark) {
                    colors.append(colorSet)
                }
            }
        })
        //print(loadedDictionary)
    }
}
