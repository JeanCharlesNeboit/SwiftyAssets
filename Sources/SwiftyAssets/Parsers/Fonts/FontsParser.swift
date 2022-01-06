//
//  FontsParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 30/07/2020.
//

import Foundation
import CoreText

struct FontFamily {
    let name: String
    let fonts: [Font]
}

class FontsParser {
    private(set) var fontFamilies = [FontFamily]()
    
    init(path: String) throws {
        try parseFonts(path: path)
    }

    private func parseFonts(path: String) throws {
        if let inputURL = URL(string: path),
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

            fontFamilies = Dictionary(grouping: fonts, by: { $0.family })
                .map { name, fonts in
                    FontFamily(name: name.removeWhitespaces(), fonts: fonts)
                }
        }
    }
}
