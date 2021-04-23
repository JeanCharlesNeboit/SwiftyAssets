//
//  ProcessExtension.swift
//  
//
//  Created by Jean-Charles Neboit on 21/04/2021.
//

import Foundation

extension Process {
    static func shell(launchPath: String, arguments: [String]) -> String {
        let task = Process()
        let pipe = Pipe()
            
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = arguments
        task.launchPath = launchPath
        task.launch()
            
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
            
        return output
    }
}
