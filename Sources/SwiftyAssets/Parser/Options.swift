//
//  Options.swift
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

enum Options: String, CaseIterable, ArgumentProtocol {
    typealias T = String
    
    case projectName = "--project-name"
    case copyright = "--copyright"
    case version = "--version"
    case plist = "--plist"
    case resources = "--resources"
    
    init?(shortName: String) {
        for option in Options.allCases {
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
        case .plist:
            return "-p"
        case .resources:
            return "-r"
        }
    }
    
    var usage: String {
        switch self {
        case .projectName:
            return "Name of the project"
        case .copyright:
            return "Copyright of the project"
        case .version:
            return "Display the current version of \(Spec.projectName)"
        case .plist:
            return "Path of your project's Info.plist"
        case .resources:
            return "Path of the resources"
        }
    }
    
    var kind: T.Type {
        return T.self
    }
    
    var completion: ShellCompletion {
        return .unspecified
    }
}

extension ArgumentParser {
    @discardableResult
    func addOption(option: Options) -> OptionArgument<String> {
        return self.add(option: option.rawValue, shortName: option.shortName, kind: option.kind, usage: option.usage, completion: option.completion)
    }
}
