//
//  FileGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

class FileHeader {
    let projectName: String?
    let copyright: String?
    let additionalLines: [String]?
    
    init(projectName: String?, copyright: String?, additionalLines: [String]? = nil) {
        self.projectName = projectName
        self.copyright = copyright
        self.additionalLines = additionalLines
    }
    
    func header(filename: String) -> String {
        let _copyright = copyright ?? "Copyright © 2020. All rights reserved."
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let header = [
            "/*",
            "\t\(filename)",
            "\(projectName?.appending("\n") ?? "")",
            "\tCreated by \(Spec.projectName) 🦊 on \(dateFormatter.string(from: Date()))",
            "\t\(additionalLines?.joined(separator: "\n").appending("\n\t") ?? "")\(_copyright)",
            "*/"
        ]
        
        return header.joined(separator: "\n")
    }
}

class FileGenerator {
    let filename: String
    let ext: Extension
    let fileHeader: FileHeader?
    let lines: [String]
    
    init(filename: String, ext: Extension, fileHeader: FileHeader?, lines: [String]) {
        self.filename = filename
        self.ext = ext
        self.fileHeader = fileHeader
        self.lines = lines
    }
    
    func generate(atPath path: String, overwrite: Bool = true) throws {
        var isDir : ObjCBool = false
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = "\(path)/\(filename)\(ext.rawValue)"
        
        guard overwrite == true || !FileManager.default.fileExists(atPath: filePath) else {
            return
        }
        
        let fileContent = "\(fileHeader?.header(filename: "\(filename)\(ext.rawValue)").appending("\n") ?? "")\(lines.joined(separator: "\n"))"
        FileManager.default.createFile(atPath: filePath, contents: fileContent.data(using: .utf8), attributes: nil)
    }
}
