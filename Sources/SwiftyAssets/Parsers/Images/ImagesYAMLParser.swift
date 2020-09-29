//
//  ImagesYAMLParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import Foundation

class ImagesYAMLParser: YAMLParser {
    private(set) var images: [ImageSet] = []

    override init(path: String) throws {
        try super.init(path: path)

        try loadedDictionary.keys.forEach({ key in
            let name = key
            if let value = loadedDictionary[key] as? [String: Any] {
                let width = value[ImageKeys.width.rawValue] as? Int
                let height = value[ImageKeys.height.rawValue] as? Int
                let _width = (width != nil) ? "\(width!)" : value[ImageKeys.width.rawValue] as? String
                let _height = (height != nil) ? "\(height!)" : value[ImageKeys.height.rawValue] as? String
                if let imageSet = try ImageSet(name: name, width: _width, height: _height) {
                    images.append(imageSet)
                }
            }
        })
    }
}
