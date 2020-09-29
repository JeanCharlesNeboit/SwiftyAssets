//
//  FontsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import TSCUtility

// MARK: - Command
public class FontsCommand: AssetsCommand, Command {
    // MARK: - Properties
    public let command: String = "fonts"
    public let overview: String = "Generate Fonts"
    
    // MARK: - Options
    public var plistOption: OptionArgument<String>?
    
    // MARK: - Initialization
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
        plistOption = subparser.addOption(option: .plist)
    }
    
    // MARK: - Run
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try FontsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
