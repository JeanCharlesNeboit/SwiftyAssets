//
//  ColorsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

public class ColorsCommand: AssetsCommand, Command {
    public let command: String = "colors"
    public let overview: String = "Generate Named Colors"
    
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
    }
    
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try ColorsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
