//
//  StringsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import TSCUtility
import SwiftCSV

class StringsGenerator: AssetsGenerator {
    // MARK: - Properties
    private var localizableStrings = LocalizableStrings()
    private var inputFileType: InputFileType = .yaml
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, command: StringsCommand) throws {
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
            if let yamlParser = try? StringsYAMLParser(path: input) {
                self.localizableStrings = yamlParser.localizableStrings
            }
        case .csv:
            #warning("ToDo")
//            if let csvParser = try? StringsCSVParser(path: input) {
//
//            }
        }
    }
    
    // MARK: - Generation
    override func generate() throws {
        try super.generate()
        
        try localizableStrings.forEach { localizable in
            try createLocalizableFolders(locale: localizable.key, translations: localizable.value)
        }
        
        let keys = Array(Set(localizableStrings.map { $0.value }.reduce([], +).map { $0.key }))
        try createSwiftFile(keys: keys)
    }
    
    private func createLocalizableFolders(locale: Locale, translations: [Translation]) throws {
        let filename = "Localizable"
        let additionalLines = ["Translated in \(locale.flag)"]
        
        var lines: [String] = [""]
        translations.forEach { translation in
            let key = translation.key
            if key.isEmpty {
                lines.append("")
            } else if key.starts(with: "//") {
                lines.append(key)
            } else {
                var value = translation.value
                value = value.replacingOccurrences(of: "\r", with: "\\r")
                value = value.replacingOccurrences(of: "\n", with: "\\n")
                lines.append("\"\(key)\" = \"\(value)\";")
            }
        }
        
        let fileGenerator = FileGenerator(filename: filename, ext: .strings, fileHeader: getFileHeader(additionalLines: additionalLines), lines: lines)
        try fileGenerator.generate(atPath: "\(output)/\(locale.id)\(Extension.lproj.rawValue)")
    }
    
    private func createSwiftFile(keys: [String]) throws {
        let filename = "SwiftyStrings"
        let path = "\(output)"
        
        var lines = [
            "",
            "import Foundation",
            "",
            "extension \(CommandLineTool.name) {",
            "\tclass Strings {"
        ]
        
        for key in keys where !key.isEmpty {
            if key.starts(with: "//") {
                lines.append("\(String(repeating: "\t", count: 2))\(key.replacingOccurrences(of: "//", with: "// MARK: -"))")
            } else {
                lines.append(contentsOf: [
                    "\(String(repeating: "\t", count: 2))static var \(key): String {",
                    "\(String(repeating: "\t", count: 3))return NSLocalizedString(\"\(key)\", comment: \"\")",
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
        try fileGenerator.generate(atPath: path)
    }
}
