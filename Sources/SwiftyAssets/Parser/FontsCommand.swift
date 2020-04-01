//
//  FontsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

// MARK: - Command
class FontsCommand: AssetsCommand, Command {
    // MARK: - Properties
    let command: String = "fonts"
    let overview: String = "Generate Fonts"
    
    // MARK: - Options
    var plistOption: OptionArgument<String>?
    
    // MARK: - Initialization
    required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
        plistOption = subparser.addOption(option: .plist)
    }
    
    // MARK: - Run
    func run(with result: ArgumentParser.Result) throws {
        let generator = try FontsGenerator(result: result, command: self)
        try generator?.generate()
    }
}

// MARK: - ArgumentParser.Result
extension FontsCommand {
    func plist(in result: ArgumentParser.Result) -> String? {
        guard let plist = plistOption else {
            return nil
        }
        return result.get(plist)
    }
}
