//
//  FileManager.swift
//  
//
//  Created by Jean-Charles Neboit on 16/03/2021.
//

import Foundation

extension FileManager {
    private var mainDirectory: URL {
        URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
    }
    
    private var templateDirectory: URL {
        mainDirectory.appendingPathComponent("FileTemplates")
    }
    
    var templateDirectoryString: String {
        templateDirectory.absoluteString.replacingOccurrences(of: "file://", with: "")
    }
}
