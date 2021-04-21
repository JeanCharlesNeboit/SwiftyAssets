//
//  FontsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 09/02/2020.
//

import Foundation
import TSCUtility
import Stencil
import PathKit

class FontsGenerator: AssetsGenerator {
    // MARK: - Properties
    private var fontFamilies = [FontFamily]()
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
        fontFamilies = parser.fontFamilies
    }
    
    // MARK: - Generation
    override func generate() throws {
        try super.generate()
        
        try createSwiftFile(fonts: fontFamilies)
        try addFontsToPList(fonts: fontFamilies.flatMap { $0.fonts })
    }
    
    private func createSwiftFile(fonts: [FontFamily]) throws {
        try generateSwiftFile(templateFile: "fonts.stencil", filename: "SwiftyFonts", additionalContext: [
            "fontFamilies": fonts
        ])
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
            log.error(message: error.localizedDescription)
        }
    }
}
