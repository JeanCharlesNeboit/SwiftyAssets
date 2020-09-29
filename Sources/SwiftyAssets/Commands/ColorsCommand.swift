//
//  ColorsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import TSCUtility

public class ColorsCommand: AssetsCommand, Command {
    // MARK: - Properties
    public let command: String = "colors"
    public let overview: String = "Generate Named Colors"
    
    // MARK: - Options
    public var inputFileTypeOption: OptionArgument<String>?
    
    // MARK: - Initialization
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
        inputFileTypeOption = subparser.addOption(option: .inputFileType)
    }
    
    // MARK: - Run
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try ColorsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
