//
//  Command.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

//enum Command: String, CaseIterable {
//    case strings
//    case colors
//    case images
//    case fonts
//
//    static var allCommandsString: String {
//        return Command.allCases.compactMap { $0.rawValue }.joined(separator: ", ")
//    }
//
//    func subparser(with parser: ArgumentParser) -> ArgumentParser? {
//        switch self {
//        case .strings, .colors:
//            return nil
//        case .images:
//            return nil
//        case .fonts:
//            return parser.add(subparser: "info.plist", overview: "The path of your app info.plist")
//        }
//    }
//}
//
//enum CommandError: LocalizedDescriptionError {
//    case commandNotExist(command: String)
//
//    var localizedDescription: String {
//        switch self {
//        case .commandNotExist(let command):
//            return "'\(command)' is not a valid command, expected: \(Command.allCommandsString)"
//        }
//    }
//}
//
//enum SubCommand: String {
//    case infoPlist = "info-plist"
//}

protocol Command {
    var command: String { get }
    var overview: String { get }

    init(parser: ArgumentParser)
    func run(with result: ArgumentParser.Result) throws
}
