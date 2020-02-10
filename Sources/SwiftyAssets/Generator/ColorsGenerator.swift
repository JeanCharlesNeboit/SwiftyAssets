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
            if !color.name.isEmpty && !color.name.starts(with: "//") {
                let colorFolder = "\(xcassetsPath)/\(color.name)\(Extension.colorset.rawValue)"
                try FileManager.default.createDirectory(atPath: colorFolder, withIntermediateDirectories: true, attributes: nil)
                try self.createColor(for: color, in: colorFolder)
            }
        }
        
        try self.createSwiftFile(colors: colors)
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
    
    private func createSwiftFile(colors: [Color]) throws {
        let filename = "SwiftyColors"
        let path = "\(output)"
        
        var lines = [
            "",
            "import UIKit",
            "",
            "extension \(Spec.projectName) {",
            "\tclass Colors {"
        ]
        
        for color in colors {
            if !color.name.isEmpty {
                if color.name.starts(with: "//") {
                    lines.append("\(String(repeating: "\t", count: 2))\(color.name.replacingOccurrences(of: "//", with: "// MARK: -"))")
                } else {
                    lines.append(contentsOf: [
                        "\(String(repeating: "\t", count: 2))static var \(color.name): UIColor? {",
                        "\(String(repeating: "\t", count: 3))return UIColor(named: \"\(color.name)\")",
                        "\(String(repeating: "\t", count: 2))}",
                        ""
                    ])
                }
            }
        }
        
        lines.append(contentsOf: [
            "\t}",
            "}"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path)
    }
}
