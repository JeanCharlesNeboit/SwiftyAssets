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
    private var inputFileType: InputFileType = .yaml
    private var stringsParser: StringsParser?
    
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
                stringsParser = yamlParser
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
        
        guard let stringsParser = stringsParser else { return }

        try stringsParser.localizables.forEach { localizable in
            let values = localizable.value.sorted(by: { $0.key < $1.key })
            try createLocalizables(locale: localizable.key, localizables: values)
        }

        try stringsParser.localizableWithFormat.forEach { localizable in
            let values = localizable.value.sorted(by: { $0.key < $1.key })
            try createLocalizablesWithFormat(locale: localizable.key, localizables: values)
        }

        let localizablesKeys = Array(Set(stringsParser.localizables.map { $0.value }.reduce([], +).map { $0.key })).sorted()
        let localizablesWithFormatKeys = Array(Set(stringsParser.localizableWithFormat.map { $0.value }.reduce([], +).map { $0.key })).sorted()
        try createSwiftFile(localizablesKeys: localizablesKeys, localizablesWithFormatKeys: localizablesWithFormatKeys)
    }
    
    private func folder(for locale: Locale) -> String {
        "\(command.output)/\(locale.id)\(Extension.lproj.rawValue)"
    }
    
    private func createLocalizables(locale: Locale, localizables: [Localizable]) throws {
        let folder = folder(for: locale)
        try generateFile(templateName: "localizable", folder: folder, filename: "Localizable", fileExtension: .strings, additionalContext: [
            "flag": locale.flag,
            "localizables": localizables
        ])
    }
    
    private func createLocalizablesWithFormat(locale: Locale, localizables: [LocalizableWithFormat]) throws {
        let folder = folder(for: locale)
        try generateFile(templateName: "localizable_plurals", folder: folder, filename: "Localizable", fileExtension: .stringsdict, additionalContext: [
            "localizables": localizables
        ])
    }
    
    private func createSwiftFile(localizablesKeys: [String], localizablesWithFormatKeys: [String]) throws {
        try generateFile(templateName: "strings", filename: "SwiftyStrings", fileExtension: .swift, additionalContext: [
            "localizables": localizablesKeys,
            "localizablesWithFormat": localizablesWithFormatKeys
        ])
        
    }
}
