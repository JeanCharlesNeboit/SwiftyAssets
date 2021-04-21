//
//  ColorsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation
import TSCUtility
import PathKit
import Stencil

class ColorsGenerator: AssetsGenerator {
    // MARK: - Properties
    private var colors = [ColorSet]()
    private var inputFileType: InputFileType = .yaml
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, command: ColorsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        if let option = result.get(command.inputFileTypeOption),
            let ext = InputFileType(ext: option) {
            inputFileType = ext
        }
        parseColors()
    }
    
    // MARK: - Parsing
    private func parseColors() {
        switch inputFileType {
        case .yaml:
            if let yamlParser = try? ColorsYAMLParser(path: input) {
                self.colors = yamlParser.colors
            }
        case .csv:
            if let csvParser = try? ColorsCSVParser(path: input) {
                self.colors = csvParser.colors
            }
        }
    }
    
    // MARK: - Generation
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
        try generateSwiftFile(templateFile: "colors.stencil", filename: "SwiftyColors", additionalContext: [
            "colors": colors
        ])
    }
}
