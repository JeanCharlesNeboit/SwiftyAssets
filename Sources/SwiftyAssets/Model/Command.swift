//
//  Command.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

enum Command: String, CaseIterable {
    case strings
    case colors
    case images
    case fonts
    
    static var allCommandsString: String {
        return Command.allCases.compactMap { $0.rawValue }.joined(separator: ", ")
    }
}

enum CommandError: LocalizedDescriptionError {
    case commandNotExist(command: String)
    
    var localizedDescription: String {
        switch self {
        case .commandNotExist(let command):
            return "'\(command)' is not a valid command, expected: \(Command.allCommandsString)"
        }
    }
}
