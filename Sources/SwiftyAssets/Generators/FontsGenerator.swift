//
//  FontsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/02/2020.
//

import Foundation
import ArgumentParser
import Stencil
import PathKit

class FontsGenerator: AssetsGenerator<FontsCommand> {
    // MARK: - Properties
    let fontFamilies: [FontFamily]
    
    // MARK: - Initialization
    override init?(command: FontsCommand, underTest: Bool = false) throws {
        guard let parser = try? FontsParser(path: command.input) else {
            return nil
        }
        fontFamilies = parser.fontFamilies
        
        try super.init(command: command, underTest: underTest)
    }
    
    // MARK: - Generation
    override func generate() throws {
        try super.generate()
        
        try createSwiftFile(fonts: fontFamilies)
        try addFontsToPList(fonts: fontFamilies.flatMap { $0.fonts })
    }
    
    private func createSwiftFile(fonts: [FontFamily]) throws {
        try generateFile(templateName: "fonts", filename: "SwiftyFonts", additionalContext: [
            "fontFamilies": fonts
        ])
    }

    private func addFontsToPList(fonts: [Font]) throws {
        guard let path = command.plist else { return }

        let plistService = PlistService(path: path)

        guard var dictionary = plistService.read() else { return }

        var fontsProvidedByApp = dictionary[PlistService.FontsProvidedByAppKey] as? [String] ?? [String]()

        fonts.filter { !fontsProvidedByApp.contains($0.fileName) }
            .forEach { fontsProvidedByApp.append($0.fileName) }

        dictionary[PlistService.FontsProvidedByAppKey] = fontsProvidedByApp

        do {
            try plistService.write(dict: dictionary)
        } catch let error {
            log.error(message: error.localizedDescription)
        }
    }
}
