//
//  Positional.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

enum Positional: String, CaseIterable {
    case command = "command"
    case input = "input"
    case output = "output"
    
    var usage: String {
        switch self {
        case .command:
            return "Type of the generation (\(Command.allCommandsString))"
        case .input:
            return "Path of the input CSV file"
        case .output:
            return "Path of the output folder where files are generated"
        }
    }
}

enum PositionalError: LocalizedDescriptionError {
    case outputNotADirectory(path: String)
    
    var localizedDescription: String {
        switch self {
        case .outputNotADirectory(let path):
            return "'\(path)' no such directory"
        }
    }
}

extension ArgumentParser {
    func addPositionals() -> [Positional: PositionalArgument<String>] {
        var positionals = [Positional: PositionalArgument<String>]()
        for positional in Positional.allCases {
            positionals[positional] = self.add(positional: positional.rawValue, kind: String.self, optional: false, usage: positional.usage, completion: ShellCompletion.none)
        }
        return positionals
    }
}
