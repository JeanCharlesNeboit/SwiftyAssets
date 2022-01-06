//
//  AssetsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import ArgumentParser

struct ProjectOptions: ParsableArguments {
    // MARK: - Properties
    @Option(name: .customLong("project-name"), help: "The name of the project.")
    var name: String?
    
    @Option(name: .shortAndLong, help: "The copyright of the project.")
    var copyright: String?
    
    var fullCopyright: String {
        if let copyright = copyright {
            return copyright
        } else {
            var defaultCopyright = "Copyright © \(DateFormatter(format: "yyyy").string(from: Date()))"

            if let name = name {
                defaultCopyright.append(contentsOf: ", \(name)")
            }
            defaultCopyright.append(contentsOf: ". All rights reserved.")
            
            return defaultCopyright
        }
    }
}

struct PathArguments: ParsableArguments {
    
}

protocol AssetsCommand: ParsableCommand {
    var input: String { get }
    var output: String { get }
    var projectOptions: ProjectOptions { get }
}

//extension AssetsCommand {    
//    func getInputFileType(in result: ArgumentParser.Result, for option: OptionArgument<String>?) -> String? {
//        guard let option = option else { return nil }
//        return result.get(option)
//    }
//}
