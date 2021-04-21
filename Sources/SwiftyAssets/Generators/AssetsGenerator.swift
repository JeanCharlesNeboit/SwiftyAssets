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
    let command: AssetsCommand
    let result: ArgumentParser.Result
    let input: String
    let output: String
    
    var projectName: String {
        command.projectName(in: result) ?? ""
    }
    
    var copyright: String {
        command.copyright(in: result)
    }
    
    // MARK: - Initialization
    init?(result: ArgumentParser.Result, assetsCommand: AssetsCommand) throws {
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
        
        self.command = assetsCommand
        self.result = result
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
    func generateSwiftFile(templateFile: String, filename: String, additionalContext: [String: Any]) throws {
        var context: [String: Any] = [
            "projectName": projectName,
            "date": DateFormatter(format: "dd/MM/yyyy").string(from: Date()),
        ]
        context += additionalContext
        
        let ext = Stencil.Extension()
        ext.registerCustomExtensions()
        
        let environment = Environment(loader: FileSystemLoader(paths: [Path(FileManager.default.templateDirectoryString)]), extensions: [ext])
        let rendered = try environment.renderTemplate(name: templateFile, context: context)
        let filePath = "\(output)/\(filename)\(Extension.swift.rawValue)"
        
        #warning("Create file if needed")
        FileManager.default.createFile(atPath: filePath, contents: rendered.data(using: .utf8), attributes: nil)
    }
}
