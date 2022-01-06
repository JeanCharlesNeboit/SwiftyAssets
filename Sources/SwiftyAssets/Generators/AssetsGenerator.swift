//
//  AssetsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import ArgumentParser
import Stencil
import PathKit

class AssetsGenerator<T: AssetsCommand> {
    // MARK: - Properties
    let command: T
    let underTest: Bool
    
    private(set) var generatedFileContent = ""
    
    // MARK: - Initialization
    init?(command: T, underTest: Bool) throws {
        self.command = command
        self.underTest = underTest

        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: command.output, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: command.output, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // MARK: -
    func getFileHeader(additionalLines: [String]? = nil) -> FileHeader {
        return FileHeader(projectName: command.projectOptions.name, copyright: command.projectOptions.fullCopyright, additionalLines: additionalLines)
    }
    
    func generate() throws {
        try generateFile(templateName: "swifty", filename: CLI.name, fileExtension: .swift, additionalContext: [:])
    }
    
    // MARK: -
    #warning("Create protocol and call generateSwiftFile directly in generate")
    func generateFile(templateName: String, folder: String? = nil, filename: String, fileExtension: Extension = .swift, additionalContext: [String: Any]) throws {
        var context: [String: Any] = [
            "projectName": command.projectOptions.name ?? "",
            "date": DateFormatter(format: "dd/MM/yyyy").string(from: Date()),
            "copyright": command.projectOptions.fullCopyright
        ]
        context += additionalContext
        generatedFileContent = Environment.getContent(templateName: templateName, context: context)
        
        if !underTest {
            FileGenerator.generate(atPath: folder ?? command.output, filename: filename, fileExtension: fileExtension, content: generatedFileContent)
        }
    }
}

extension Environment {
    static func getContent(templateName: String, context: [String: Any]) -> String {
        let ext = Stencil.Extension()
        ext.registerCustomExtensions()
        
        let environment = Environment(loader: FileSystemLoader(paths: [Path(FileManager.default.templateDirectoryString)]), extensions: [ext])
        do {
            return try environment.renderTemplate(name: "\(templateName).stencil", context: context)
        } catch {
            log.error(message: error.localizedDescription)
            return ""
        }
    }
}
