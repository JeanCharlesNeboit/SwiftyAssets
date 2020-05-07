//
//  StringsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

public class StringsCommand: AssetsCommand, Command {
    public let command: String = "strings"
    public let overview: String = "Generate Localizable Strings"
    
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
    }
    
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try StringsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
