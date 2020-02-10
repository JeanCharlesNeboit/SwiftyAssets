//
//  FontsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/02/2020.
//

import Foundation

class FontsGenerator: AssetsGenerator {
    typealias FontFamily = String
    
    private var fontsGroupedByFamily: [FontFamily: [Font]] = [:]
    
    override init?(parser: SwiftyParser) throws {
        try super.init(parser: parser)
        
        try parseFonts()
        try createSwiftFile(fonts: fontsGroupedByFamily)
    }
    
    private func parseFonts() throws {
        if let inputURL = URL(string: input),
            let enumerator = FileManager.default.enumerator(at: inputURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                print("directoryEnumerator error at \(url): ", error)
                return true
            }) {

            var fonts: [Font] = []
            for case let fileURL as URL in enumerator {
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
            "extension \(Spec.projectName) {",
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
}