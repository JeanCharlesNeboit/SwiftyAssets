//
//  ImagesCSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 15/04/2020.
//

import Foundation

class ImagesCSVParser: CSVParser {
    private(set) var images: [ImageSet] = []
    
    override init(path: String) throws {
        try super.init(path: path)
        
        for namedRow in csv.namedRows {
            if let name = namedRow[ImageKeys.name.rawValue],
                let width = namedRow[ImageKeys.width.rawValue],
                let height = namedRow[ImageKeys.height.rawValue] {
                if let imageSet = try ImageSet(name: name, width: width, height: height) {
                    images.append(imageSet)
                }
            }
        }
    }
}
