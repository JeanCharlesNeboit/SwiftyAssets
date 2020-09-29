//
//  StringsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import TSCUtility

public class StringsCommand: AssetsCommand, Command {
    // MARK: - Properties
    public let command: String = "strings"
    public let overview: String = "Generate Localizable Strings"
    
    // MARK: - Options
    public var inputFileTypeOption: OptionArgument<String>?
    
    // MARK: - Initialization
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
        inputFileTypeOption = subparser.addOption(option: .inputFileType)
    }
    
    // MARK: - Run
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try StringsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
