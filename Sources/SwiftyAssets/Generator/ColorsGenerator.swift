//
//  ColorsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation
import SPMUtility

class ColorsGenerator: AssetsGenerator {
    private var csvParser: ColorsCSVParser?
    
    init?(result: ArgumentParser.Result, command: ColorsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        self.csvParser = try ColorsCSVParser(path: input)
    }
    
    override func generate() throws {
        try super.generate()
        try generateColors()
    }
    
    private func generateColors() throws {
        let xcassetsPath = "\(output)/\(Spec.projectName)\(Extension.xcassets.rawValue)/Colors"
        
        guard let colors = csvParser?.colors else {
            return
        }
        
        for color in colors {
            guard !color.name.isEmpty && !color.name.starts(with: "//") else { return }
            
            let colorsetFolder = "\(xcassetsPath)/\(color.name)\(Extension.colorset.rawValue)"
            try FileManager.default.createDirectory(atPath: colorsetFolder, withIntermediateDirectories: true, attributes: nil)
            try self.generateColorset(for: color, in: colorsetFolder)
        }
        
        try self.generateSwiftFile(colors: colors)
    }
    
    private func generateColorset(for color: Color, in folder: String) throws {
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
    
    private func generateSwiftFile(colors: [Color]) throws {
        let filename = "SwiftyColors"
        
        var lines = [
            "",
            "import UIKit",
            "",
            "extension \(Spec.projectName) {",
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
