//
//  ColorsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

class ColorsGenerator: AssetsGenerator {
    private var csvParser: ColorsCSVParser?
    
    override init?(parser: SwiftyParser) throws {
        try super.init(parser: parser)
        self.csvParser = try ColorsCSVParser(input: input, output: output)
        
        
    }
    
    override func generate() throws {
        try super.generate()
        
        try createColorsXCAssets()
    }
    
    private func createColorsXCAssets() throws {
        let xcassetsPath = "\(output)/\(Spec.projectName)\(Extension.xcassets.rawValue)/Colors"
        
        guard let colors = csvParser?.colors else {
            return
        }
        
        for color in colors {
            let colorFolder = "\(xcassetsPath)/\(color.name)\(Extension.colorset.rawValue)"
            try FileManager.default.createDirectory(atPath: colorFolder, withIntermediateDirectories: true, attributes: nil)
            try createColor(for: color, in: colorFolder)
        }
    }
    
    private func createColor(for color: Color, in folder: String) throws {
        let filename = "Contents"

        var info = ColorSet.info
        info.appendToLast(newElement: ",")
        
        var lines = ["{"]
        lines.append(contentsOf: info)
        lines.append(contentsOf: color.json)
        lines.append("}")
        
        let fileGenerator = FileGenerator(filename: filename, ext: .json, fileHeader: nil, lines: lines)
        try fileGenerator.generate(atPath: folder)
    }
    
    private func createSwiftFile(keys: [String]) throws {
        
    }
}
