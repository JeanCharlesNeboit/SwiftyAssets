//
//  AssetsGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

class AssetsGenerator {
    let swiftyParser: SwiftyParser
    let input: String
    let output: String
    
    init?(parser: SwiftyParser) throws {
        guard let inputPositional = parser.positionals[Positional.input],
            let inputArg = parser.result.get(inputPositional) else {
            return nil
        }

        guard let outputPositional = parser.positionals[Positional.output],
            let outputArg = parser.result.get(outputPositional) else {
            return nil
        }

        var isDir : ObjCBool = false
        guard FileManager.default.fileExists(atPath: outputArg, isDirectory: &isDir) else {
            throw PositionalError.outputNotADirectory(path: outputArg)
        }
        
        self.swiftyParser = parser
        self.input = inputArg
        self.output = outputArg
        
        //        let projectName = 
        //        let copyright = v
    }
    
    func getFileHeader(additionalLines: [String]? = nil) -> FileHeader {
        return FileHeader(projectName: swiftyParser.projectName, copyright: swiftyParser.copyright, additionalLines: additionalLines)
    }
    
    public func createAssetsClassFile() throws {
        let filename = "\(Spec.projectName)"
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
