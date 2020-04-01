//
//  StringsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility
import SwiftCSV

class StringsGenerator: AssetsGenerator {
    private var csvParser: StringsCSVParser?
    
    init?(result: ArgumentParser.Result, command: StringsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        self.csvParser = try StringsCSVParser(input: input, output: output)
    }
    
    override func generate() throws {
        try super.generate()
        
        guard let languages = csvParser?.languages,
            let keys = csvParser?.keys else {
            return // TODO:
        }
        
        for language in languages {
            try createLocalizableFolders(language: language, keys: keys)
        }
        
        try createSwiftFile(keys: keys)
    }
    
    private func createLocalizableFolders(language: Language, keys: [String]) throws {
        let filename = "Localizable"
        let additionalLines = ["Translated in \(language.flag)"]
        
        var lines: [String] = [""]
        for (i, key) in keys.enumerated() {
            if key.isEmpty {
                lines.append("")
            } else if key.starts(with: "//") {
                lines.append(key)
            } else {
                if language.translatedStrings.count > i {
                    var value = language.translatedStrings[i]
                    value = value.replacingOccurrences(of: "\r", with: "\\r")
                    value = value.replacingOccurrences(of: "\n", with: "\\n")
                    lines.append("\"\(key)\" = \"\(value)\";")
                }
            }
        }
        
        let fileGenerator = FileGenerator(filename: filename, ext: .strings, fileHeader: getFileHeader(additionalLines: additionalLines), lines: lines)
        try fileGenerator.generate(atPath: "\(output)/\(language.code)\(Extension.lproj.rawValue)")
    }
    
    private func createSwiftFile(keys: [String]) throws {
        let filename = "SwiftyStrings"
        let path = "\(output)"
        
        var lines = [
            "",
            "import Foundation",
            "",
            "extension \(Spec.projectName) {",
            "\tclass Strings {"
        ]
        
        for key in keys {
            if !key.isEmpty {
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
        }
        
        lines.append(contentsOf: [
            "\t}",
            "}"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path)
    }
}
