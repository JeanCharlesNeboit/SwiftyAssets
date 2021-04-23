//
//  LogService.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 27/10/2020.
//

import Foundation

let log = LoggerService.shared

class LoggerService {
    static let shared = LoggerService()
    
    func warning(message: String) {
        log(type: "warning", message: message)
    }
    
    func error(message: String) {
        log(type: "error", message: message)
        exit(1)
    }
    
    private func log(type: String, message: String) {
        print("\(type): [\(CommandLineTool.name)] \(message)")
    }
}
