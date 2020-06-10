//
//  Positionals.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 18/02/2020.
//

import Foundation

enum Positional {
    case input(String)
    case output(String)
    case plist
    
    var value: String {
        switch self {
        case .input:
            return "input"
        case .output:
            return "output"
        case .plist:
            return "plist"
        }
    }
    
    var usage: String {
        switch self {
        case .input(let command):
            return "Path of the \(command) CSV file"
        case .output(let command):
            return "Path of the folder where \(command) will be generated"
        case .plist:
            return "Path of your project's Info.plist"
        }
    }
}
