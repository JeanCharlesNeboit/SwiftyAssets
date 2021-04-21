//
//  FontExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 10/02/2020.
//

import AppKit.NSFont
import Foundation

extension CTFont {
    static func parse(url: URL) -> [Font] {
        let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL)
        guard let fontDescriptors = (descriptors as? [CTFontDescriptor]) else { return [] }
        
        return fontDescriptors.compactMap { descriptor -> Font? in
            let fileName = url.lastPathComponent
            let font = CTFontCreateWithFontDescriptorAndOptions(descriptor, 0.0, nil, [.preventAutoActivation])
            let postScriptName = CTFontCopyPostScriptName(font) as String
            
            guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String,
                let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String else { return nil }
            
            return Font(fileName: fileName, family: familyName, postScriptName: postScriptName, style: style.removeWhitespaces().lowercasedFirst())
        }
    }
}
