//
//  AssetsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

class AssetsGenerator {
    let command: AssetsCommand
    let result: ArgumentParser.Result
    let input: String
    let output: String
    
    init?(result: ArgumentParser.Result, assetsCommand: AssetsCommand) throws {
        guard let inputArg = result.get(assetsCommand.inputPositional) else {
            return nil
        }

        guard let outputArg = result.get(assetsCommand.outputPositional) else {
            return nil
        }

        var isDir : ObjCBool = true
        if !FileManager.default.fileExists(atPath: outputArg, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: outputArg, withIntermediateDirectories: true, attributes: nil)
        }
        
        self.command = assetsCommand
        self.result = result
        self.input = inputArg
        self.output = outputArg
    }
    
    func getFileHeader(additionalLines: [String]? = nil) -> FileHeader {
        let projectName = command.projectName(in: result)
        let copyright = command.copyright(in: result)
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
            "",
            "}"
        ]
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: path, overwrite: false)
    }
    
    func generate() throws {
        try createAssetsClassFile()
    }
}
