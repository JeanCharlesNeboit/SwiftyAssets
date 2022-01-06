//
//  ColorsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation
import ArgumentParser
import PathKit
import Stencil

class ColorsGenerator: AssetsGenerator<ColorsCommand> {
    // MARK: - Properties
    private(set) var colors = [ColorSet]()
    private var inputFileType: InputFileType = .yaml
    
    // MARK: - Initialization
    override init?(command: ColorsCommand, underTest: Bool = false) throws {
        try super.init(command: command, underTest: underTest)
        
        if let ext = InputFileType(ext: command.inputFileType) {
            inputFileType = ext
        }
        parseColors()
    }
    
    // MARK: - Parsing
    private func parseColors() {
        switch inputFileType {
        case .yaml:
            if let yamlParser = try? ColorsYAMLParser(path: command.input) {
                self.colors = yamlParser.colors
            }
        case .csv:
            if let csvParser = try? ColorsCSVParser(path: command.input) {
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
        let xcassetsPath = "\(command.output)/\(CLI.name)\(Extension.xcassets.rawValue)/Colors"
        
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
            FileGenerator.generate(atPath: folder, filename: "Contents", fileExtension: .json, content: content)
        }
    }
    
    private func generateSwiftFile(colors: [ColorSet]) throws {
        try generateFile(templateName: "colors", filename: "SwiftyColors", additionalContext: [
            "colors": colors
        ])
    }
}
