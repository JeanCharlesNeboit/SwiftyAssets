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
    private(set) var colors = [ColorSet]()
    private var inputFileType: InputFileType = .yaml
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, command: ColorsCommand, underTest: Bool = false) throws {
        try super.init(result: result, assetsCommand: command, underTest: underTest)
        
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
        let content = Environment.getContent(templateName: "asset_contents", context: [
            "content": color.json.joined(separator: "\n")
        ])
        
        if !underTest {
            FileGenerator.generate(atPath: folder, filename: "Contents", ext: .json, content: content)
        }
    }
    
    private func generateSwiftFile(colors: [ColorSet]) throws {
        try generateSwiftFile(templateName: "colors", filename: "SwiftyColors", additionalContext: [
            "colors": colors
        ])
    }
}
