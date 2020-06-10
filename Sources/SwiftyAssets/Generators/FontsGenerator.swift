//
//  FontsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/02/2020.
//

import Foundation
import SPMUtility

class FontsGenerator: AssetsGenerator {
    typealias FontFamily = String
    
    private var fontsGroupedByFamily: [FontFamily: [Font]] = [:]
    private var plistPath: String?
    
    init?(result: ArgumentParser.Result, command: FontsCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        plistPath = command.plist(in: result)
        
        try parseFonts()
        try createSwiftFile(fonts: fontsGroupedByFamily)
        try addFontsToPList(fonts: fontsGroupedByFamily.flatMap({ dict in
            return dict.value
        }))
    }
    
    private func parseFonts() throws {
        if let inputURL = URL(string: input),
            let enumerator = FileManager.default.enumerator(at: inputURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                print("DirectoryEnumerator error at \(url): ", error)
                return true
            }) {

            var fonts: [Font] = []
            for case let fileURL as Foundation.URL in enumerator {
                if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileURL.pathExtension as CFString, nil) {
                    if UTTypeConformsTo(uti.takeRetainedValue(), kUTTypeFont) {
                        fonts.append(contentsOf: CTFont.parse(url: fileURL))
                    }
                }
            }
            
            self.fontsGroupedByFamily = Dictionary(grouping: fonts, by: { $0.family })
        }
    }
    
    private func createSwiftFile(fonts: [FontFamily: [Font]]) throws {
        let filename = "SwiftyFonts"
        let path = "\(output)"
        
        var lines = [
            "",
            "import UIKit",
            "",
            "extension \(CommandLineTool.name) {",
            "\tclass Font {"
        ]
        
        for (i, family) in fonts.keys.enumerated() {
            if let fonts = fonts[family] {
                lines.append("\((i == 0) ? "" : "\n")\(String(repeating: "\t", count: 2))enum \(family.removeWhitespaces()): String {")
                for font in fonts {
                    lines.append(contentsOf: [
                        "\(String(repeating: "\t", count: 3))case \(font.style.removeWhitespaces().lowercasedFirst()) = \"\(font.postScriptName)\""
                    ])
                }
            }
        }
        
        lines.append(contentsOf: [
            "",
            "\(String(repeating: "\t", count: 3))func font(withSize size: CGFloat) -> UIFont {",
            "\(String(repeating: "\t", count: 4))return UIFont(name: self.rawValue, size: size)!",
            "\(String(repeating: "\t", count: 3))}",
            "\(String(repeating: "\t", count: 2))}",
            "\t}",
            "}"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path)
    }
    
    private func addFontsToPList(fonts: [Font]) throws {
        guard let path = plistPath else { return }
        
        let plistService = PlistService(path: path)
        
        guard var dictionary = plistService.read() else {
            return
        }
        
        var fontsProvidedByApp = dictionary[PlistService.FontsProvidedByAppKey] as? [String] ?? [String]()
        
        fonts.forEach { font in
            fontsProvidedByApp.append(font.fileName)
        }
        
        dictionary[PlistService.FontsProvidedByAppKey] = fontsProvidedByApp
        
        try plistService.write(dict: dictionary)
    }
}
