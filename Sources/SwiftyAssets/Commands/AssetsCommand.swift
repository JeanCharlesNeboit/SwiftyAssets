//
//  AssetsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import TSCUtility

public class AssetsCommand {
    let subparser: ArgumentParser
    let inputPositional: PositionalArgument<String>
    let outputPositional: PositionalArgument<String>
    
    var projectNamePositional: OptionArgument<String>?
    var copyrightPositional: OptionArgument<String>?
    
    init(parser: ArgumentParser, command: String, overview: String) {
        subparser = parser.add(subparser: command, overview: overview)
        
        let input = Positional.input(command)
        inputPositional = subparser.add(positional: input.value, kind: String.self, usage: input.usage)
        
        let output = Positional.output(command)
        outputPositional = subparser.add(positional: output.value, kind: String.self, usage: output.usage)
        
        projectNamePositional = subparser.addOption(option: .projectName)
        copyrightPositional = subparser.addOption(option: .copyright)
    }
}

extension AssetsCommand {
    func projectName(in result: ArgumentParser.Result) -> String? {
        guard let projectName = projectNamePositional else {
            return nil
        }
        return result.get(projectName)
    }

    func copyright(in result: ArgumentParser.Result) -> String {
        var defaultCopyright = "Copyright © 2020"
        
        if let projectName = projectName(in: result) {
            defaultCopyright.append(contentsOf: ", \(projectName)")
        }
        defaultCopyright.append(contentsOf: ". All rights reserved.")
        
        guard let copyright = copyrightPositional else {
            return defaultCopyright
        }
        
        return result.get(copyright) ?? defaultCopyright
    }
    
    func getInputFileType(in result: ArgumentParser.Result, for option: OptionArgument<String>?) -> String? {
        guard let option = option else { return nil }
        return result.get(option)
    }
}
