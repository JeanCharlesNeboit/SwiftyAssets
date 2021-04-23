//
//  AssetsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import TSCUtility
import Stencil
import PathKit

class AssetsGenerator {
    // MARK: - Properties
    let result: ArgumentParser.Result
    let command: AssetsCommand
    let underTest: Bool
    let input: String
    let output: String
    
    private(set) var generatedFileContent = ""
    
    var projectName: String {
        command.projectName(in: result) ?? ""
    }
    
    var copyright: String {
        command.copyright(in: result)
    }
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, assetsCommand: AssetsCommand, underTest: Bool) throws {
        guard let inputArg = result.get(assetsCommand.inputPositional) else {
            return nil
        }

        guard let outputArg = result.get(assetsCommand.outputPositional) else {
            return nil
        }

        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: outputArg, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: outputArg, withIntermediateDirectories: true, attributes: nil)
        }
        
        self.result = result
        self.command = assetsCommand
        self.underTest = underTest
        self.input = inputArg
        self.output = outputArg
    }
    
    // MARK: -
    func getFileHeader(additionalLines: [String]? = nil) -> FileHeader {
        return FileHeader(projectName: projectName, copyright: copyright, additionalLines: additionalLines)
    }
    
    public func createAssetsClassFile() throws {
        let filename = "\(CommandLineTool.name)"
        let path = "\(output)"
        
        let lines = [
            "",
            "import Foundation",
            "",
            "class \(filename) {",
            "}"
        ]
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path, overwrite: false)
    }
    
    func generate() throws {
        try createAssetsClassFile()
    }
    
    // MARK: -
    #warning("Create protocol and call generateSwiftFile directly in generate")
    func generateSwiftFile(templateName: String, filename: String, additionalContext: [String: Any]) throws {
        var context: [String: Any] = [
            "projectName": projectName,
            "date": DateFormatter(format: "dd/MM/yyyy").string(from: Date()),
            "copyright": copyright
        ]
        context += additionalContext
        generatedFileContent = Environment.getContent(templateName: templateName, context: context)
        
        if !underTest {
            FileGenerator.generate(atPath: output, filename: filename, ext: .swift, content: generatedFileContent)
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
