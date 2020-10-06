//
//  FontsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/02/2020.
//

import Foundation
import TSCUtility

class FontsGenerator: AssetsGenerator {
    // MARK: - Properties
    private var fontsGroupedByFamily: [FontFamily: [Font]] = [:]
    private var plistPath: String?
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, command: FontsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        plistPath = result.get(command.plistOption)
        parseFonts()
    }
    
    // MARK: - Parsing
    private func parseFonts() {
        guard let parser = try? FontsParser(path: input) else {
            return
        }
        fontsGroupedByFamily = parser.fontsGroupedByFamily
    }
    
    // MARK: - Generation
    override func generate() throws {
        try super.generate()
        
        try createSwiftFile(fonts: fontsGroupedByFamily)
        try addFontsToPList(fonts: fontsGroupedByFamily.flatMap({ dict in
            return dict.value
        }))
    }
    
    private func createSwiftFile(fonts: [FontFamily: [Font]]) throws {
        let filename = "SwiftyFonts"
        let path = "\(output)"

        var lines = [
            "",
            "import Foundation",
            "",
            "protocol SwiftyAssetsFontProtocol {",
            "\tvar postScriptName: String { get }",
            "}",
            "",
            "extension \(CommandLineTool.name) {",
            "\tclass Font {"
        ]
        
        for (i, family) in fonts.keys.enumerated() {
            if let fonts = fonts[family] {
                lines.append("\((i == 0) ? "" : "\n")\(String(repeating: "\t", count: 2))enum \(family.removeWhitespaces()): String, SwiftyAssetsFontProtocol {")
                for font in fonts {
                    lines.append(contentsOf: [
                        "\(String(repeating: "\t", count: 3))case \(font.style.removeWhitespaces().lowercasedFirst()) = \"\(font.postScriptName)\""
                    ])
                }
                lines.append(contentsOf: [
                    "",
                    "\(String(repeating: "\t", count: 3))var postScriptName: String {",
                    "\(String(repeating: "\t", count: 4))return self.rawValue",
                    "\(String(repeating: "\t", count: 3))}",
                    "\(String(repeating: "\t", count: 2))}"
                ])
            }
        }

        lines.append(contentsOf: [
            "\t}",
            "}",
            "",
            "#if canImport(UIKit)",
            "import UIKit",
            "",
            "extension SwiftyAssetsFontProtocol {",
            "\(String(repeating: "\t", count: 1))func font(withSize size: CGFloat) -> UIFont {",
            "\(String(repeating: "\t", count: 2))return UIFont(name: self.postScriptName, size: size)!",
            "\(String(repeating: "\t", count: 1))}",
            "}",
            "#endif",
            "",
            "#if canImport(SwiftUI)",
            "import SwiftUI",
            "",
            "extension SwiftyAssetsFontProtocol {",
            "\(String(repeating: "\t", count: 1))func font(withSize size: CGFloat) -> Font {",
            "\(String(repeating: "\t", count: 2))return Font.custom(self.postScriptName, size: size)",
            "\(String(repeating: "\t", count: 1))}",
            "",
            "\(String(repeating: "\t", count: 1))func font(withSize size: CGFloat, relativeTo style: Font.TextStyle) -> Font {",
            "\(String(repeating: "\t", count: 2))return Font.custom(self.postScriptName, size: size, relativeTo: style)",
            "\(String(repeating: "\t", count: 1))}",
            "}",
            "#endif"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path)
    }

    private func addFontsToPList(fonts: [Font]) throws {
        guard let path = plistPath else { return }

        let plistService = PlistService(path: path)

        guard var dictionary = plistService.read() else { return }

        var fontsProvidedByApp = dictionary[PlistService.FontsProvidedByAppKey] as? [String] ?? [String]()

        fonts.filter { !fontsProvidedByApp.contains($0.fileName) }
            .forEach { fontsProvidedByApp.append($0.fileName) }

        dictionary[PlistService.FontsProvidedByAppKey] = fontsProvidedByApp

        do {
            try plistService.write(dict: dictionary)
        } catch let error {
            print("error: \(error)")
            exit(1)
        }
    }
}
