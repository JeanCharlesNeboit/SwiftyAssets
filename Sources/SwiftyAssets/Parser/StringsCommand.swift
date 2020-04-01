//
//  StringsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

class StringsCommand: AssetsCommand, Command {
    let command: String = "strings"
    let overview: String = "Generate Localizable Strings"
    
    required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
    }
    
    func run(with result: ArgumentParser.Result) throws {
        let generator = try StringsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
