//
//  ImagesCSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 15/04/2020.
//

import Foundation

fileprivate enum ImageHeader: String {
    case name = "Name"
    case width = "Width"
    case height = "Height"
}

class ImagesCSVParser: CSVParser {
    private(set) var images: [Image] = []
    
    override init(input: String, output: String) throws {
        try super.init(input: input, output: output)
        
        for namedRow in csv.namedRows {
            if let name = namedRow[ImageHeader.name.rawValue],
                let _width = namedRow[ImageHeader.width.rawValue],
                let _height = namedRow[ImageHeader.height.rawValue] {
                
                let width = Int(_width) ?? nil
                let height = Int(_height) ?? nil
                images.append(Image(name: name, width: width, height: height))
            }
        }
    }
}
