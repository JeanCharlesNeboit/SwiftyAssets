//
//  ColorsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation
import SPMUtility

class ColorsGenerator: AssetsGenerator {
    private var colors = [ColorSet]()
    
    init?(result: ArgumentParser.Result, command: ColorsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        if let csvParser = try? ColorsCSVParser(path: input),
            colors.count != 0 {
            self.colors = csvParser.colors
        } else if let yamlParser = try? ColorsYAMLParser(path: input) {
            self.colors = yamlParser.colors
        }
    }
    
    override func generate() throws {
        try super.generate()
        try generateColors()
    }
    
    private func generateColors() throws {
        let xcassetsPath = "\(output)/\(CommandLineTool.name)\(Extension.xcassets.rawValue)/Colors"
        
        for color in colors {
            guard !color.name.isEmpty && !color.name.starts(with: "//") else { return }
            
            let colorsetFolder = "\(xcassetsPath)/\(color.name)\(Extension.colorset.rawValue)"
            try FileManager.default.createDirectory(atPath: colorsetFolder, withIntermediateDirectories: true, attributes: nil)
            try self.generateColorset(for: color, in: colorsetFolder)
        }
        
        try self.generateSwiftFile(colors: colors)
    }
    
    private func generateColorset(for color: ColorSet, in folder: String) throws {
        let filename = "Contents"

        var info = AssetsSet.info
        info.appendToLast(newElement: ",")
        
        var lines = ["{"]
        lines.append(contentsOf: info)
        lines.append(contentsOf: color.json)
        lines.append("}")
        
        let fileGenerator = FileGenerator(filename: filename, ext: .json, fileHeader: nil, lines: lines)
        try fileGenerator.generate(atPath: folder)
    }
    
    private func generateSwiftFile(colors: [ColorSet]) throws {
        let filename = "SwiftyColors"
        
        var lines = [
            "",
            "import UIKit",
            "",
            "extension \(CommandLineTool.name) {",
            "\tclass Colors {"
        ]
        
        for color in colors {
            guard !color.name.isEmpty else { return }
            
            if color.name.starts(with: "//") {
                lines.append("\(String(repeating: "\t", count: 2))\(color.name.replacingOccurrences(of: "//", with: "// MARK: -"))")
            } else {
                lines.append(contentsOf: [
                    "\(String(repeating: "\t", count: 2))static var \(color.name): UIColor {",
                    "\(String(repeating: "\t", count: 3))return UIColor(named: \"\(color.name)\")!",
                    "\(String(repeating: "\t", count: 2))}",
                    ""
                ])
            }
        }
        
        lines.append(contentsOf: [
            "\t}",
            "}"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: output)
    }
}
