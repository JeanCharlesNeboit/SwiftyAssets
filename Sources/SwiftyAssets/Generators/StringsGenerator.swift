//
//  StringsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import ArgumentParser
import SwiftCSV

class StringsGenerator: AssetsGenerator<StringsCommand> {
    // MARK: - Properties
    private var localizableStrings = LocalizableStrings()
    private var inputFileType: InputFileType = .yaml
    
    // MARK: - Initialization
    override init?(command: StringsCommand, underTest: Bool = false) throws {
        try super.init(command: command, underTest: underTest)
        
        if let ext = InputFileType(ext: command.inputFileType) {
            inputFileType = ext
        }
        parseStrings()
    }
    
    // MARK: - Parsing
    private func parseStrings() {
        switch inputFileType {
        case .yaml:
            if let yamlParser = try? StringsYAMLParser(path: command.input) {
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
        let folder = "\(command.output)/\(locale.id)\(Extension.lproj.rawValue)"
        try generateFile(templateName: "localizable", folder: folder, filename: "Localizable", fileExtension: .strings, additionalContext: [
            "flag": locale.flag,
            "localizables": translations
        ])
    }
    
    private func createSwiftFile(keys: [String]) throws {
        try generateFile(templateName: "strings", filename: "SwiftyStrings", fileExtension: .strings, additionalContext: [
            "localizables": keys
        ])
    }
}
