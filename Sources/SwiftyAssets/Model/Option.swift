//
//  Option.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 06/02/2020.
//

import Foundation
import SPMUtility

protocol ArgumentProtocol {
    associatedtype T
    
    var usage: String { get }
    var kind: T.Type { get }
    var completion: ShellCompletion { get }
}

enum Option: String, CaseIterable, ArgumentProtocol {
    typealias T = String
    
    case projectName = "--project-name"
    case copyright = "--copyright"
    case version = "--version"
    
    init?(shortName: String) {
        for option in Option.allCases {
            if option.shortName == shortName {
                self = option
                return
            }
        }
        return nil
    }
    
    var shortName: String {
        switch self {
        case .projectName:
            return "-n"
        case .copyright:
            return "-c"
        case .version:
            return "-v"
        }
    }
    
    var usage: String {
        switch self {
        case .projectName:
            return "Name of the project"
        case .copyright:
            return "Copyright of the project"
        case .version:
            return "Current version of \(Spec.projectName)"
        }
    }
    
    var kind: T.Type {
        return T.self
    }
    
    var completion: ShellCompletion {
        return .unspecified
    }
    
    var withAction: Bool {
        switch self {
        case .version:
            return true
        default:
            return false
        }
    }
    
    func action() {
        switch self {
        case .version:
            print("\(Spec.projectName) \(Spec.version)")
            exit(0)
        default:
            break
        }
    }
}

extension ArgumentParser {
    func addOptions() -> [Option: OptionArgument<String>] {
        var options = [Option: OptionArgument<String>]()
        for option in Option.allCases {
            options[option] = self.add(option: option.rawValue, shortName: option.shortName, kind: option.kind, usage: option.usage, completion: option.completion)
        }
        return options
    }
}
