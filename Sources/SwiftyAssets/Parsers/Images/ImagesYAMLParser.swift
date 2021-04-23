//
//  ImagesYAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import Foundation
import SwiftyKit
import Yams

class ImagesYAMLParser {
    // MARK: - Properties
    private(set) var images: [ImageSet] = []

    // MARK: - Initialization
    init(path: String) throws {
        let parser = try YAMLParser(path: path)
        try parse(yaml: parser.loadedDictionary)
    }
    
    init(yaml: String) throws {
        let _yaml = try Yams.load(yaml: yaml) as? [String: Any] ?? [:]
        try parse(yaml: _yaml)
    }
    
    // MARK: -
    private func parse(yaml: [String: Any]) throws {
        try yaml.keys.forEach { key in
            let name = key
            if let value = yaml[key] as? [String: Any] {
                let format = value[ImageKeys.format()] as? String
                let width = value[ImageKeys.width()] as? Int
                let height = value[ImageKeys.height()] as? Int
                let imageSet = try ImageSet(name: name, format: format, width: width, height: height)
                images.append(imageSet)
            } else {
                throw ImagesParserError.badFormat(key: key)
            }
        }
    }
}
