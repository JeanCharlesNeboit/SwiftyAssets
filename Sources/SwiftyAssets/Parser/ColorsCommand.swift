//
//  ColorsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

class ColorsCommand: AssetsCommand, Command {
    let command: String = "colors"
    let overview: String = "Generate Named Colors"
    
    required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
    }
    
    func run(with result: ArgumentParser.Result) throws {
        let generator = try ColorsGenerator(result: result, command: self)
        try generator?.generate()
    }
}
